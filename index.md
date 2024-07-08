---
title: Jason Kielpinski
---

## About

Hello! I do appsec stuff, and also like making/playing games, Russian language, and reading fantasy and sci-fi. Contact me at first dot lаst аt gmаil.

## Security research

* [Predicting .NET's System.Random (Xoshiro256**) output (2024)](posts/predicting-system-dot-random)  
	Development of a proof of concept exploit for predicting the next output from .NET's System.Random class based on previous random outputs.

* [Impersonating Other Players with UDP Spoofing in Mirror (2023)](https://blog.includesecurity.com/2023/04/impersonating-local-unity-players-with-udp-spoofing-in-mirror/)  
	Reverse engineering deep dive into Mirror, a multiplayer game framework. 

* [Hacking Unity Games with Malicious GameObjects, Part 2 (2022)](https://blog.includesecurity.com/2022/09/hacking-unity-games-with-malicious-gameobjects-part-2/)  
	Expansion of the part 1 post, with a zero-click exploit variant along with alternative attacks.

* [Hacking Unity Games With Malicious GameObjects (2021)](https://web.archive.org/web/20210624033913/https://blog.includesecurity.com/2021/06/hacking-unity-games-malicious-unity-game-objects/)  
	Found a novel technique for attacking Unity games that load AssetBundles from untrusted sources, ultimately resulting in arbitrary code execution.

* [Dependency Confusion Vulnerabilities in Unity Games (2021)](https://web.archive.org/web/20210515212146/https://blog.includesecurity.com/2021/04/dependency-confusion-vulnerabilities-in-unity-game-development/)  
	Discussion of how dependency confusion vulnerabilities might affect Unity game supply chains.

* [Custom Static Analysis Rules in Semgrep vs. Brakeman (2021)](https://blog.includesecurity.com/2021/01/custom-static-analysis-rules-showdown-brakeman-vs-semgrep/)  
	Walking through the process of making static analysis rules for a Rails application using two popular tools.

* [Interfaces.d to RCE (2020)](https://research.nccgroup.com/2020/02/10/interfaces-d-to-rce/)  
	Found an unauthenticated remote code execution vulnerability in the Mozilla WebThings gateway.

* [Security in a Vacuum: Hacking the Neato Botvac Connected Part 1 (2018)](https://github.com/jkielpinski/vacuum-sec/blob/master/PART1_Security%20in%20a%20Vacuum-%20Hacking%20the%20Neato%20Botvac%20Connected.md)  
	Talked about tooling/test setup for assessing a WiFi-enabled robot vacuum and vulnerabilities found, including remote code execution via command injection.

* [Security in a Vacuum: Hacking the Neato Botvac Connected Part 2 (2018)](https://github.com/jkielpinski/vacuum-sec/blob/master/PART2_Security%20in%20a%20Vacuum-%20Hacking%20the%20Neato%20Botvac%20Connected.md)  
	Development of a convenient exploit for the remote code execution vulnerability discovered in part one, which involved setting up separate I/O channels (HTTP log for input, DNS for output).