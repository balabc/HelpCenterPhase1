({
    doneRendering: function(component, event, helper) {
        window.setTimeout(
            $A.getCallback(function() {
                var documentHeight = document.body.scrollHeight,
                    windowHeight = window.innerHeight,
                    target = component.find('prefooter');

                if (documentHeight === windowHeight || documentHeight === 0) {
                    $A.util.addClass(target, 'smallContent');
                } else {
                    $A.util.removeClass(target, 'smallContent');
                }
            }), 500
        );
    },
    showNewPage: function (cmp, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");

        urlEvent.setParams({
            "url": cmp.get('v.url')
        });

        urlEvent.fire();
    }
})