({
	afterRender: function(c) {
		var classname = c.get("v.class"),
			xlinkhref = c.get("v.xlinkHref"),
			ariaHidden = c.get("v.ariaHidden"),
			svgEl = '';

		svgEl = '<svg class="'+ classname +'" aria-hidden="'+ ariaHidden +'">'
			+ '<use xlink:href="'+ xlinkhref +'"></use>'
			+ '</svg>';

		c.set('v.svgEl', svgEl);
	}
})