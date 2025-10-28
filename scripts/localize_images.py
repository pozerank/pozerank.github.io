#!/usr/bin/env python3
import os
import re
import hashlib
from pathlib import Path
from urllib import request, parse, error

POSTS_DIR = Path("_posts")
IMAGES_ROOT = Path("images")

IMAGE_MARKDOWN_REGEX = re.compile(r'!\[[^\]]*\]\((https?://[^)]+)\)')
IMAGE_HTML_REGEX = re.compile(r'src=["\'](https?://[^"\']+)["\']', re.IGNORECASE)
IMAGE_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".webp", ".svg", ".bmp", ".tiff", ".ico"}


def ensure_directory(path: Path) -> None:
    path.mkdir(parents=True, exist_ok=True)


def sanitize_filename(url: str, used_names: set[str]) -> str:
    url = normalize_url(url)
    parsed = parse.urlparse(url)
    name = Path(parsed.path).name
    if not name:
        name = hashlib.md5(url.encode("utf-8")).hexdigest()[:10] + ".png"
    name = parse.unquote(name)
    name = re.sub(r'[^A-Za-z0-9.\-_]', '_', name)
    original_name = name
    counter = 1
    while name in used_names:
        stem, dot, suffix = original_name.partition(".")
        suffix = suffix or "png"
        name = f"{stem}_{counter}.{suffix}" if dot else f"{stem}_{counter}"
        counter += 1
    used_names.add(name)
    return name


def download_image(url: str, destination: Path) -> bool:
    url = normalize_url(url)
    if destination.exists():
        return True
    try:
        req = request.Request(url, headers={"User-Agent": "Mozilla/5.0"})
        with request.urlopen(req) as response, open(destination, "wb") as output_file:
            output_file.write(response.read())
    except (error.URLError, error.HTTPError, ValueError) as exc:
        print(f"Failed to download {url}: {exc}")
        return False
    return True


def replace_urls(content: str, replacements: dict[str, str]) -> str:
    for old, new in replacements.items():
        content = content.replace(old, new)
    return content


def normalize_url(url: str) -> str:
    return re.sub(r"\s+", "", url)


def is_image_url(url: str) -> bool:
    parsed = parse.urlparse(url)
    suffix = Path(parsed.path).suffix.lower()
    return suffix in IMAGE_EXTENSIONS


def main():
    post_files = list(POSTS_DIR.glob("*.md")) + list(POSTS_DIR.glob("*.markdown"))
    for post_path in post_files:
        slug = post_path.stem
        post_images_dir = IMAGES_ROOT / slug
        ensure_directory(post_images_dir)

        content = post_path.read_text(encoding="utf-8")
        urls = set(IMAGE_MARKDOWN_REGEX.findall(content))
        urls.update(IMAGE_HTML_REGEX.findall(content))

        if not urls:
            continue

        used_names = set()
        replacements: dict[str, str] = {}

        for raw_url in urls:
            url = normalize_url(raw_url)
            if not is_image_url(url):
                continue
            filename = sanitize_filename(url, used_names)
            local_path = post_images_dir / filename
            if download_image(url, local_path):
                new_url = f"/images/{slug}/{filename}"
                replacements[raw_url] = new_url

        new_content = replace_urls(content, replacements)
        if new_content != content:
            post_path.write_text(new_content, encoding="utf-8")
            print(f"Processed {post_path}")


if __name__ == "__main__":
    main()
