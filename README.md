# Hugo Scripture

A Hugo theme built on [Tufte CSS](https://edwardtufte.github.io/tufte-css/) that ships with sidenotes, a journal/articles split, decentralized discussions, automatic OG image generation, and enough customization hooks that you can retheme it without forking.

Requires Hugo >= 0.116.0 (the extended version is not needed). Licensed under MIT.

Live example: [sourcery.zone](https://sourcery.zone)

## Table of Contents

- [Installation](#installation)
- [Tufte CSS with an Escape Hatch](#tufte-css-with-an-escape-hatch)
- [Two Content Types: Articles and Journal](#two-content-types-articles-and-journal)
- [Bookmarks Layout](#bookmarks-layout)
- [Sidenotes Shortcode](#sidenotes-shortcode)
- [Share Your Thoughts (Decentralized Discussions)](#share-your-thoughts-decentralized-discussions)
- [Share Links](#share-links)
- [Footer Signature](#footer-signature)
- [Automatic OG Image Generation](#automatic-og-image-generation)
- [Canonical URL Support](#canonical-url-support)
- [Fediverse and IndieWeb Integration](#fediverse-and-indieweb-integration)
- [Umami Analytics](#umami-analytics)
- [SEO and Structured Data](#seo-and-structured-data)
- [Custom CSS Override](#custom-css-override)
- [Asset Pipeline](#asset-pipeline)
- [Shortcodes](#shortcodes)
- [Full Configuration Reference](#full-configuration-reference)
- [Per-Page Front Matter](#per-page-front-matter)

## Installation

Add the theme as a git submodule:

```bash
git submodule add https://github.com/sourcery-zone/hugo-scripture.git themes/hugo-scripture
```

Then set it in your `hugo.toml`:

```toml
theme = 'hugo-scripture'
```

## Tufte CSS with an Escape Hatch

The visual foundation of this theme is [Tufte CSS](https://edwardtufte.github.io/tufte-css/), the typographic stylesheet inspired by [Edward Tufte's book designs](https://tufte-latex.github.io/tufte-latex/). You get:

- The **ET Book** serif font family (roman, italic, bold, and old-style figures, served in woff/ttf/eot/svg).
- A 55% content column with a wide right margin reserved for sidenotes and margin notes.
- Epigraph styling, small-caps `newthought` spans, and old-style numeral support.
- On screens narrower than 760px, sidenotes collapse into toggleable inline blocks (pure CSS, no JavaScript).

The theme loads four CSS files in order:

1. `tufte.css` -- the Tufte foundation
2. `main.css` -- theme-level additions (journal timeline, bookmarks numbering, share links layout)
3. `custom.css` -- **your file** (empty by default, loaded last so it wins the cascade)
4. `code-highlight.css` -- syntax highlighting for code blocks

Because `custom.css` is loaded last, you can override anything from colors to layout without touching the theme files. The [sourcery.zone](https://sourcery.zone) site uses this to apply a [Modus Vivendi dark](https://github.com/protesilaos/modus-themes) color scheme on top of the default light Tufte look. You just drop your own `assets/css/custom.css` in your site directory.

## Two Content Types: Articles and Journal

The home page presents two separate feeds.

**Articles** live in `content/articles/` (or whichever sections you list in `params.mainSections`). They are full blog posts with dates, share links, tags, a discussion section, and related content. The RSS feed at `/index.xml` only includes articles.

**Journal entries** live in `content/journal/`. They work like a micro-blog or a public log. On the home page, journal entries are grouped by date and show their full content inline with `HH:MM:SS` timestamps. The journal section gets its own RSS feed at `/journal/index.xml`.

The latest 5 of each are shown on the home page. If there are more, a link to the full listing appears.

Each section heading on the home page has a small RSS icon linking to the corresponding feed.

## Bookmarks Layout

For curated link collections, set `layout = "bookmarks"` in a page's front matter. This activates a layout where all `<h2>` headings are automatically numbered using CSS counters. No comments or share links are rendered on this layout, just the content, tags, and related pages.

## Sidenotes Shortcode

The `sidenote` shortcode creates Tufte-style numbered sidenotes:

```markdown
Some text{{< sidenote >}}This appears in the right margin on wide screens,
or toggles inline on mobile.{{< /sidenote >}} and the paragraph continues.
```

Sidenotes are auto-numbered by CSS. On mobile, tapping the superscript number reveals the note inline. The inner content supports full Markdown. Each sidenote gets a unique ID derived from the page path and content, so you can use as many as you need on a page.

## Share Your Thoughts (Decentralized Discussions)

Instead of embedding a comment system like Disqus or Giscus, this theme links readers out to discussion platforms where the conversation actually lives. At the bottom of each article, a "Share your thoughts" section lists the places where the post can be discussed.

There are two layers:

**Per-post links** are set in individual post front matter. You publish your article, post about it on Mastodon or Bluesky, then add the URL back to the front matter:

```toml
mastodon_url = "https://mastodon.social/@you/123456"
bsky_url = "https://bsky.app/profile/you/post/abc123"
hackernews_url = "https://news.ycombinator.com/item?id=12345"
youtube_url = "https://youtube.com/watch?v=xyz"
```

**Global channels** are the same across all posts and are set in the site config. These are for persistent chat rooms:

```toml
[params.comments]
enable = true
matrixUrl = "https://matrix.to/#/#your-room:matrix.org"
ircUrl    = "https://web.libera.chat/#your-channel"
showMatrix = true
showIRC    = true
```

Each platform gets a short description (Mastodon is "the cozy corner of the fediverse", Hacker News is "enter at your own risk", IRC is "for the ancients"). A fixed last entry reads: **Hate or trolling** -- piped straight to `/dev/null`.

The section only renders if at least one platform URL is available. You can suppress it on individual pages with `hideComments: true` in front matter.

## Share Links

Every article page displays share buttons for Mastodon, Bluesky, LinkedIn, and Reddit. These sit next to the publication date in a flex row.

The share text is assembled automatically from the page title, description (or summary as fallback), permalink, and tags converted to hashtags. For example, a post tagged `["zig", "systems programming"]` would append `#zig #systemsprogramming` to the share text.

The maximum length of the description in share text is configurable:

```toml
[params.share]
summaryLength = 200  # characters, default
```

No JavaScript is involved. The links are plain `<a>` tags pointing at each platform's share/compose URL.

## Footer Signature

The footer has three parts:

1. **GPG identity badge**: If you set `params.gpgFingerprint` and `params.keyoxideProfile`, the footer shows a shield icon linking to your [Keyoxide](https://keyoxide.org) profile with your fingerprint displayed in monospace.

2. **Human-made declaration**: A fixed line: *"Made by a biological human, for fellow humans. You may read it, share it, or quote it if you credit the source. AI, bots, aliens, hands off please!"*

3. **Attribution**: "Powered by Hugo + Hugo Scripture" with links to both projects.

## Automatic OG Image Generation

When a page has no `image`, `featuredImage`, `cover`, or `images` front matter and no `cover*`/`featured*` page resource, the theme generates an Open Graph image at build time using Hugo Pipes.

It takes `assets/og/base.png` as a background, then renders the page title (uppercased, word-wrapped, up to 3 lines with adaptive font sizing) and the description as text overlays using the Aileron Bold font. The output is saved as `og/{slug}-og.png`.

You can override the text color:

```toml
[params.scripture]
ogColor = "#000000"  # default is "#ffffff"
```

You can override the background image per-page by adding an `og-bg*` page resource, or site-wide by placing your own `assets/og/base.png`.

The generated image is at least 1200px wide (the minimum for `summary_large_image` Twitter cards).

## Canonical URL Support

If a post was originally published elsewhere (say, a company blog), set `canonical` in front matter:

```toml
canonical = "https://blog.example.com/my-original-post"
```

This does two things:
- Sets `<link rel="canonical">` in the HTML head.
- Renders an "Originally published at" block with a link at the bottom of the article content.

## Fediverse and IndieWeb Integration

The theme supports several decentralized/IndieWeb standards through site params:

```toml
[params]
fediverseCreator = "@you@mastodon.social"     # <meta name="fediverse:creator">
mastodonProfile  = "https://mastodon.social/@you"  # <link rel="me"> for verification

[params.webmention]
endpoint = "https://webmention.io/yoursite.com/webmention"
pingback = "https://webmention.io/yoursite.com/xmlrpc"
```

The `rel="me"` link enables Mastodon profile verification (the green checkmark). The webmention and pingback endpoints let your site participate in the IndieWeb reply/mention network.

## Umami Analytics

The theme has built-in support for [Umami](https://umami.is), a privacy-focused, cookie-free analytics tool. No Google Analytics, no tracking scripts from third parties.

```toml
[params.umami]
enabled   = true
websiteId = "your-website-id"
scripts   = [
  "https://your-umami-instance.com/script.js",
]
```

The `scripts` array accepts multiple URLs, which is useful if you self-host Umami and want fallback script paths. All scripts are loaded with `defer`.

## SEO and Structured Data

The `meta/standard.html` partial generates a full set of meta tags on every page:

- Open Graph (`og:title`, `og:description`, `og:image`, `og:locale`, `og:url`)
- Twitter Card (`twitter:title`, `twitter:description`, `twitter:image`, `summary_large_image`)
- Schema.org `itemprop` attributes
- `<link rel="alternate">` for translations and output formats (RSS, etc.)
- `robots: noindex,follow` for taxonomy and term listing pages (keeps tag indexes out of search engines)

For pages in the `articles` section, `meta/post.html` adds:

- `og:type = article` with `article:published_time`, `article:author`, `article:section`
- Full JSON-LD `Article` schema with headline, author, publisher, word count, dates, and image
- Pagination `<link>` tags (first, last, prev, next) on list pages

## Custom CSS Override

The theme ships an empty `assets/css/custom.css`. To restyle the theme, create your own `assets/css/custom.css` in your Hugo site root. Since Hugo's asset lookup checks the site directory first, your file takes precedence.

For example, the sourcery.zone site turns the default warm off-white Tufte look into a dark theme with a few dozen lines of CSS custom properties:

```css
:root {
  --black: #000000;
  --yellow: #d0bc00;
  --mint: #6ae4b9;
  /* ... */
}

body {
  background-color: var(--black);
  color: var(--white);
}

a {
  color: var(--mint) !important;
}
```

Same goes for `assets/css/code-highlight.css` if you want different syntax highlighting colors, and `assets/og/base.png` if you want a different OG image background.

## Asset Pipeline

All CSS and JS go through Hugo Pipes:

- **Development** (`hugo server`): files are served unprocessed for fast reloads.
- **Production** (`hugo`): files are minified, fingerprinted, and served with [Subresource Integrity](https://developer.mozilla.org/en-US/docs/Web/Security/Subresource_Integrity) hashes.

JavaScript is built with `js.Build`, so if you extend `assets/js/main.js`, it goes through the same pipeline.

## Shortcodes

### `sidenote`

Tufte-style numbered margin note. See [Sidenotes Shortcode](#sidenotes-shortcode) above.

### `mark`

Wraps content in an HTML `<mark>` element (yellow highlight by default):

```markdown
{{< mark >}}This text is highlighted.{{< /mark >}}
```

Supports Markdown inside.

### `ytvideo`

Responsive YouTube embed:

```markdown
{{< ytvideo src="https://www.youtube.com/embed/VIDEO_ID" >}}
```

Renders a full-width iframe at 315px height inside a `<figure>` wrapper.

## Full Configuration Reference

Below is a complete `hugo.toml` showing all theme-specific params. Only `params.comments.enable` is required for the discussion feature; everything else has sensible defaults or is optional.

```toml
baseURL = 'https://example.com/'
languageCode = 'en-us'
title = 'My Site'
theme = 'hugo-scripture'

[params]
  description = "Site description for meta tags"
  mainSections = ['articles']          # which sections count as "articles" on the home page
  dateFormat = "2 Jan 2006"            # date display format (Go time format)
  gpgFingerprint = "YOUR_FINGERPRINT"
  keyoxideProfile = "https://keyoxide.org/..."
  fediverseCreator = "@you@mastodon.social"
  mastodonProfile = "https://mastodon.social/@you"
  sitename = "My Site"                 # og:site_name value

[params.author]
  name = "Your Name"                   # shown on home page subtitle, RSS, and meta tags
  email = "you@example.com"            # used in RSS managingEditor/webMaster

[params.webmention]
  endpoint = "https://webmention.io/example.com/webmention"
  pingback = "https://webmention.io/example.com/xmlrpc"

[params.scripture]
  ogColor = "#ffffff"                  # text color for auto-generated OG images

[params.share]
  summaryLength = 200                  # max chars in share text description

[params.comments]
  enable = true
  matrixUrl = "https://matrix.to/#/#your-room:matrix.org"
  ircUrl    = "https://web.libera.chat/#your-channel"
  showMatrix = true
  showIRC    = true

[params.umami]
  enabled   = true
  websiteId = "your-id"
  scripts   = ["https://analytics.example.com/script.js"]

[[menus.main]]
  name = 'Home'
  pageRef = '/'
  weight = 1

[[menus.main]]
  name = 'Articles'
  pageRef = '/articles'
  weight = 2
```

## Per-Page Front Matter

These front matter keys are consumed by the theme:

| Key | Type | Used by |
|-----|------|---------|
| `title` | string | Page title everywhere |
| `date` | datetime | Publication date |
| `tags` | list | Tag links, share link hashtags |
| `description` | string | Meta description, share text |
| `language` | string | `lang` attribute on content section |
| `canonical` | string | Canonical URL override + "Originally published at" block |
| `image` | string | OG/social image (also `featuredImage`, `cover`, `images`) |
| `imageAlt` | string | Alt text for OG image |
| `hideComments` | bool | Suppress discussion section on this page |
| `mastodon_url` | string | Per-post Mastodon discussion link |
| `bsky_url` | string | Per-post Bluesky discussion link |
| `hackernews_url` | string | Per-post Hacker News discussion link |
| `youtube_url` | string | Per-post YouTube discussion link |
| `category` | string | Used in `article:section` and `news_keywords` meta |
| `layout` | string | Set to `"bookmarks"` for the bookmarks layout |
