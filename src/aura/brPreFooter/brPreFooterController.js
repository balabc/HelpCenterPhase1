({
    doneRendering: function(component, event, helper) {
        if ($A.get("$Browser.formFactor") !== 'PHONE') {
            var documentHeight = document.body.scrollHeight,
                windowHeight = window.innerHeight,
                target = component.find('prefooter');
            if ((documentHeight > windowHeight) && component.get('v.defineLargeContentSize')) {
                return;
            }
            if (window.location.href.includes('profile')) {
                if (documentHeight > windowHeight) {
                    target.getElement().style.display = 'block';
                } else {
                    target.getElement().style.display = 'none';
                }
            } else {
                if (documentHeight === windowHeight || documentHeight === 0) {
                    if (!component.get('v.defineSmallContentSize')) {
                        $A.util.addClass(target, 'smallContent');
                        component.set('v.defineSmallContentSize', true);
                    }
                } else {
                    $A.util.removeClass(target, 'smallContent');
                    component.set('v.defineLargeContentSize', true);
                }
            }
        }

    }
})