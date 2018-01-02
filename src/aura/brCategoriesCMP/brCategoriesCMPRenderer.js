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

               //console.log(docNavTriggersLength);

                while (i <= docNavTriggersLength) {
                    docNavTriggers[i].addEventListener('click', events.toggleList, false);
                    i++;
                }
            }() );

            ( function docNavPositionAnimate() {
                var cnNavFixed = 'doc-nav--fixed',
                    nav = document.getElementsByClassName('doc-nav')[0],
                    header = document.getElementsByClassName('header-pad')[0],
                    breadcrumbs = document.getElementsByClassName('breadcrumbs')[0],
                    preFooter = document.getElementsByClassName('pre-footer')[0],
                    headerHeight = header.offsetHeight,
                    breadcrumbsHeight = breadcrumbs.offsetHeight,
                    docNavDecorMarginBottom = 20,
                    docNavInitPosTop = '70px',
                    navDocScrollEv = function () {
                        if (window.scrollY > breadcrumbsHeight) {
                            nav.classList.add(cnNavFixed);

                            if (( nav.offsetHeight + headerHeight ) > ( preFooter.getBoundingClientRect().top - docNavDecorMarginBottom )) {
                                nav.style.top = -( nav.offsetHeight - preFooter.getBoundingClientRect().top + docNavDecorMarginBottom ) + 'px';
                            } else {
                                nav.style.top = docNavInitPosTop;
                            }
                        } else {
                            nav.classList.remove(cnNavFixed);
                        }
                    };

                window.addEventListener('scroll', navDocScrollEv, false);
            }() );
        }
    }
})