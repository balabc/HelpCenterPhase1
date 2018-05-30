({
    afterRender: function (component, helper) {
        this.superAfterRender();

        if ($A.get('$Browser.formFactor') !== 'PHONE') {


            ( function docNavAnimate() {
                var selectors = {
                        docNavTriggerLvl1: '.doc-nav__link-lvl-1',
                        docNavTriggerLvl2: '.doc-nav__link-lvl-2'
                    },
                    docNavTriggers = document.querySelectorAll(selectors.docNavTriggerLvl1 + ', ' + selectors.docNavTriggerLvl2),
                    events = {
                        toggleList: function (e) {
                            var parentClasses = this.parentElement.classList;

                            e.preventDefault();
                            parentClasses.contains('active') ?
                                parentClasses.remove('active') :
                                parentClasses.add('active');
                        }
                    },
                    i = 0,
                    docNavTriggersLength = docNavTriggers.length - 1;

                while (i <= docNavTriggersLength) {
                    docNavTriggers[i].addEventListener('click', events.toggleList, false);
                    i++;
                }
            }() );
        }
    }
})