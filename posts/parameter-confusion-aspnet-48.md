---
title: Parameter confusion in ASP.NET Framework 4.8
author: Jason Kielpinski
date: October 19, 2025
modified: October 19, 2025
keywords: [ASP.NET, authorization, ASP.NET 4.8, ASP.NET Framework, security, logic flaw, gotcha]
---


## Intro

Recently I encountered an unexpected behavior regarding route parameters in ASP.NET Framework 4.8, which is the older but still supported branch of ASP.NET (the newer one being ASP.NET Core). If one is unaware of this behavior it can have significant security implications. TLDR: don't rely on `RequestContext.RouteData` for security decisions.

## Background

A little terminology first to make sure we're on the same page. [RFC 1738](https://datatracker.ietf.org/doc/html/rfc1738) defines URLs in the following way:

~~~
http://<host>:<port>/<path>?<searchpart>
~~~

Web applications can accept parameters in either the `<path>` portion, called **route parameters**, or the `<searchpart>` portion, called **query parameters**.

## Unexpected behavior

Inspect the following ASP.NET endpoint:

~~~csharp
public class ValuesController : ApiController
{
    [Route("entities/{entityId}")]
    [EntityAuthzFilter]
    public string GetEntity(string entityId)
    {
        return RetrieveEntityDetails(entityId);
    }

    private string RetrieveEntityDetails(string entityId)
    {
        //... actual logic would go here
        return entityId;
    }
}
~~~

It defines a route, `/entities/{entityId}`, which takes a route parameter, `entityId`. What would you expect the value of `entityId` to be if this endpoint was invoked via the following URL?

~~~
https://127.0.0.1:443/entities/123?entityId=456 
~~~

It turns out, the answer depends on which ASP.NET version you are using. In version 8, the `entityId` gets set to 123, which is what I expected to happen. However, in 4.8, the query parameter overrides the route parameter and `entityId` becomes 456.

## Why could this be bad?

Imagine the `EntityAuthzFilter` attribute applied to the endpoint above has the following logic:

~~~csharp
public class EntityAuthzFilterAttribute : ActionFilterAttribute
{
    public override void OnActionExecuting(HttpActionContext actionContext)
    {
        var user = actionContext.RequestContext.Principal;
        var entityId = actionContext.RequestContext.RouteData.Values["entityId"] as string;
        if (!ValidateAccess(entityId, user))
        {
            actionContext.Response = actionContext.Request.CreateErrorResponse(HttpStatusCode.Forbidden, "Access to this entity is forbidden.");
        }
    }

    private bool ValidateAccess(string entityId, IPrincipal user)
    {
    	//... custom logic here
    }
}
~~~

This could be an elegant solution for validating access control on entities by globally ensuring that any endpoint with an `entityId` route parameter checks that the user has authorization to access the entity. That is... except for the fact that query parameters can override route parameters!

Suppose a user is allowed to access entity 123 but *not* allowed to access 456. When the user goes to `/entities/456`, authorization is applied successfully:

![](posts/parameter-confusion-aspnet-48/1_authz.png)

However, when the user goes to `/entities/123?entityId=456`, the application returns the data for entity 456:

![](posts/parameter-confusion-aspnet-48/2_bypass.png)

This is because the authorization is performed on the route parameter, 123 (which the user is authorized to access), but the actual logic in the controller method happens using the parameter that was overridden by the query parameter, 456 (which the user is NOT authorized to access).

## How to fix

ASP.NET 8 does not have this behavior, so upgrading would fix it if possible.

There is no `[FromRoute]` attribute in ASP.NET 4.8, but you *can* override the value provider to explicitly only allow a parameter to be populated by route data:

~~~csharp
public string GetEntity([ValueProvider(typeof(RouteDataValueProviderFactory))] string entityId)
{
    return RetrieveEntityDetails(entityId);

}
~~~

This can also be done globally if you do not ever need parameters to come from the query string:

~~~csharp
public static class WebApiConfig
{
    public static void Register(HttpConfiguration config)
    {
        config.Services.Replace(
            typeof(ValueProviderFactory),
            new RouteDataValueProviderFactory()
        );
        //...
    }
    //...
}
~~~

Otherwise, I would recommend not relying on `HttpContext.RouteData` for authorization decisions in ASP.NET 4.8.