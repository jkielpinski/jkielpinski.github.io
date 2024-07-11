# Generate main page
pandoc -s --embed-resources --mathjax -f markdown -t html5 --css style.css \
    -o "public_html/index.html" \
    "index.md"

# Generate posts
for file in posts/*.md; do
    base=$(basename -- "$file");
    post="${base%.*}"
    echo $post

    mkdir -p "public_html/posts/$post"

    pandoc -s --embed-resources --mathjax --css style.css \
        -f markdown -t html5 \
        -o "public_html/posts/$post/index.html" \
        "post-header.md" \
        "posts/$post.md"
done