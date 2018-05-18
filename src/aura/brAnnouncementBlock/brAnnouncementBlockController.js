({
    doInit: function (component) {
        var action = component.get('c.getAnnouncement');

        action.setStorable();
        action.setBackground();

        action.setCallback(this, function(response) {
            var state = response.getState(),
                res = response.getReturnValue();

            if (state === 'SUCCESS') {
                if (res !== null) {
                    res.QualifiedApiName = res.QualifiedApiName.toLowerCase();
                    component.set('v.notice', res);
                    component.set('v.showNotification', true);
                } else {
                    component.set('v.showNotification', false);
                }
            }
        });

        $A.enqueueAction(action);
    },

    closeAnnouncementBlock: function (component) {
        var dropDownMenu = document.getElementsByClassName('header__wrap-dropdown-menu')[0],
            header = document.getElementsByClassName('header')[0],
            headerMobile = document.getElementsByClassName('header-mobile')[0];

        document.getElementsByClassName('announcement-block')[0].style.display = 'none';

        if (headerMobile !== undefined) {
            headerMobile.style.top = '0';
        } else if (header != undefined) {
            header.style.top = '0';
            dropDownMenu.style.top = '70px';
        }
    }
})