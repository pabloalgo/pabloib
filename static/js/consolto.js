/**
 * Consolto Video Chat Widget Loader
 * Externalized from inline script to comply with CSP (no unsafe-inline).
 */
window.addEventListener("load", () => {
	var el = document.createElement("script");
	el.setAttribute("src", "https://client.consolto.com/iframeApp/iframeApp.js");
	el.id = "et-iframe";
	el.async = true;
	el.setAttribute("data-widgetId", "65e937c3dcea669377311401");
	el.setAttribute("data-version", 0.5);
	el.setAttribute("data-test", false);
	document.body.appendChild(el);
});
