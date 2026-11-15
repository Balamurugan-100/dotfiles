// ─── Firefox Reproducible user.js ───────────────────────────────────────────
// Catppuccin Mocha + Wayland/macOS Performance + Privacy & Smooth Scrolling

// 1. Enable custom CSS stylesheets (userChrome.css & userContent.css)
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("svg.context-properties.content.enabled", true);
user_pref("layout.css.color-mix.enabled", true);

// 2. Force Dark Theme & Catppuccin Mocha scheme
user_pref("ui.systemUsesDarkTheme", 1);
user_pref("browser.theme.content-theme", 2);
user_pref("browser.theme.toolbar-theme", 2);
user_pref("layout.css.prefers-color-scheme.content-override", 0);

// 3. Hardware Acceleration & WebRender
user_pref("gfx.webrender.all", true);
user_pref("media.ffmpeg.vaapi.enabled", true);
user_pref("media.rdd-ffmpeg.enabled", true);
user_pref("widget.wayland.opaque-region", true);
user_pref("widget.dmabuf.force-enabled", true);

// 4. Snappy Smooth Scrolling
user_pref("general.smoothScroll", true);
user_pref("general.smoothScroll.msdPhysics.enabled", true);
user_pref("general.smoothScroll.lines.durationMaxMS", 125);
user_pref("general.smoothScroll.pages.durationMaxMS", 150);

// 5. Clean UI & Compact Density
user_pref("browser.compactmode.show", true);
user_pref("browser.uidensity", 1);
user_pref("browser.tabs.tabmanager.enabled", false);

// 6. Privacy & Disable Telemetry
user_pref("datareporting.healthreport.uploadEnabled", false);
user_pref("datareporting.policy.dataSubmissionEnabled", false);
user_pref("toolkit.telemetry.unified", false);
user_pref("toolkit.telemetry.enabled", false);
user_pref("toolkit.telemetry.server", "data:,");
user_pref("toolkit.telemetry.archive.enabled", false);
user_pref("browser.discovery.enabled", false);
user_pref("extensions.pocket.enabled", false);

// 7. Clean New Tab Page (No Ads or Sponsored Content)
user_pref("browser.newtabpage.activity-stream.showSponsored", false);
user_pref("browser.newtabpage.activity-stream.showSponsoredTopSites", false);
user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
user_pref("browser.newtabpage.activity-stream.feeds.snippets", false);
