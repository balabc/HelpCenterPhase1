({
    closeAnnouncementBlock: function (component) {
        document.getElementsByClassName('announcement-block')[0].style.display = 'none';
        var dropDownMenu = document.getElementsByClassName('header__wrap-dropdown-menu')[0],
            header = document.getElementsByClassName('header')[0],
            headerMobile = document.getElementsByClassName('header-mobile')[0];

        if (headerMobile !== undefined) {
            headerMobile.style.top = '0';
        } else if (header != undefined) {
            header.style.top = '0';
            dropDownMenu.style.top = '70px';
        }
    }
})