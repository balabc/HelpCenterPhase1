a,
a.link,
.link,
a.link--sm,
.link--sm,
a.link--xsm,
.link--xsm {
    font-family: 'source_sans_prosemibold', Arial, sans-serif;
    text-decoration: none !important;
    color: #4b71fc;
    transition: all 0.3s ease;
}
input.header__searchbox-input-text::placeholder {
    font-size: 0.9375rem;
    font-family: 'source_sans_prosemibold', Arial, sans-serif;
    color: #ffffff;
}
.uiPanel--notificationsPanel.open.active {
    top: 65px !important;
    z-index: 36 !important;
}
.uiPanel--notificationsPanel.open.active > .container {
    position: relative !important;
    padding: 0;
    border-radius: 5px;
    background: #ffffff;
    box-shadow: 0 4px 10px 0 rgba(35, 46, 105, 0.1);
}
.uiPanel--notificationsPanel > .container > .panel-content {
    margin-bottom: 0;
}
.container > .panel-header > .uiButton {
    display: none;
}
.uiPanel>.pointer {
    top: -8px !important;
    border-style: solid;
    width: 0;
    height: 0;
    border-width: 9px 4px 4px 9px;
    border-color: transparent transparent #ffffff transparent;
}
.unsNotificationsListRow {
    border-top: none !important;
}
.unsNotificationsPanel .titleContainer {
    display: table !important;
    vertical-align: middle;
    width: 100% !important;
    padding: 0;
    padding: 0 !important;
    border-radius: 5px 5px 0 0;
    border-bottom: 2px solid #d1d7e0 !important;
}
span.titleName {
    display: table-cell;
    width: 50%;
    padding: 11px 10px 11px 23px !important;
    text-align: left;
    font-family: 'source_sans_proregular', Arial, sans-serif !important;
    font-size: 1.125rem !important;
    line-height: 1.5625rem;
    letter-spacing: 0;
    font-weight: normal !important;
    color: #34313f !important;
}
span.titleOptions {
    display: table-cell !important;
    width: 50%;
    padding: 10px;
    text-align: center;
    line-height: 1.5rem;
    overflow: hidden;
    white-space: nowrap;
    text-overflow: ellipsis;
}
.unsNotificationsPanel .titleAction a {
    font-family: 'source_sans_prosemibold', Arial, sans-serif;
    text-decoration: none !important;
    font-size: 0.9375rem !important;
    color: #4b71fc;
    transition: all 0.3s ease;
}
.listContainer.scrollable {
    overflow-y: auto !important;
    height: auto;
    margin: 0;
    padding: 0;
    border-radius: 0 0 5px 5px;
    list-style: none;
}
.scroller > ul {
    height: auto;
    margin: 0 !important;
    padding: 0 !important;
    border-radius: 0 0 5px 5px;
    list-style: none;
}
.unsNotificationsVirtualList {
    max-height: 480px;
}
.unsNotificationsListRow.notification-row {
    display: block;
    position: relative;
    border-bottom: 2px solid #d1d7e0;
    background: #ffffff;
}
.unsNotificationsListRow.notification-row:nth-child(odd) {
    background: #f5f7ff;
}
.unsNotificationsListRow.notification-row:nth-child(even) {
    background: #ffffff !important;
}
.unsNotificationsListRow.notification-row:last-child {
    border: none !important;
}

.unsNotificationsListRow .notification-content:first-child {
    padding-left: 45px;
}
.unsNotificationsListRow .notification-icon {
    position: absolute;
    top: 22px;
    left: 24px;
    width: 34px !important;
    height: 34px !important;
    border-radius: 50% !important;
}
span.notification-text-title.uiOutputText {
    display: block;
    margin-bottom: 5px;
    font-family: 'source_sans_prosemibold', Arial, sans-serif;
    font-size: 0.875rem;
    line-height: 1.1875rem;
}
span.notification-text.uiOutputText {
    display: block;
    font-family: 'source_sans_proregular', Arial, sans-serif;
    font-size: 0.875rem;
    line-height: 1.1875rem;
}
span.notification-age {
    margin-top: 10px;
    font-family: 'source_sans_proregular', Arial, sans-serif;
    font-size: 0.8125rem !important;
    line-height: 1.1875rem;
    color: #6d6e7a !important;
}
span.notification-age.uiOutputText:after {
    content: ' in BigCommerce Community';
}
a.notification-link {
    position: relative;
    padding: 20px 20px 20px 25px !important;
}
.unsNotificationsListRow .assistive-unread-mark {
    color: #4b71fc !important;
}
.header-mobile__right .cBrNotifications .unsNotificationsCounter .headerButtonBody {
    right: 5px;
    z-index: 36;
}
.DESKTOP .unsNotificationsPanel>div {
    width: 365px !important;
}
.visible {
    display: none !important;
}
body.mobile-menu-is-active .header-mobile__nav[data-active="true"] {
    display: block;
}

body.mobile-menu-is-active .header-mobile__nav[data-active="false"] {
    display: none;
}
.is-mobile .serp__filter-section {
    z-index: -1 !important;
}
.panel-media {
    padding: 43px 43px 43px 33px;
}
.panel-media__wrap-icon {
    width: 112px;
}
.panel-media__icon img {
    width: 112px;
}
.panel-media__wrap-content {
    padding-left: 140px;
}
.videoDescription {
    width: 336px;
}

@media only screen and (max-width: 992px) {

    .area-video__right, .area-video__left {
        padding: 0 30px !important;
    }
    .videoDescription {
        width: 100% !important;
        padding: 0 29px 0 30px !important;
    }
    .is-mobile .serp__filter-section {
        z-index: -1 !important;
    }
}

.is-mobile .doc-nav__item-lvl-1 .doc-nav__list-lvl-2 .doc-nav__link-lvl-2.doc-nav__link-lvl-2--numeric.hide-nav-arrow {
    padding: 15px 25px 14px 35px;
}

.button.button--primary.disabled {
    cursor: not-allowed;
    background-color: #f8f9fb;
    border: 1px solid #e3e3e5;
    cursor: not-allowed;
    pointer-events: none;
    opacity: .65;
    -webkit-box-shadow: none;
    box-shadow: none;
}

.icon-svg-arrow-angular-lg-left-white:before {
    background-position: -13px -21px;
    -webkit-transform: translate(-50%, -50%) rotate(180deg);
    transform: translate(-50%, -50%) rotate(180deg);
}

.icon-svg-arrow-angular-lg-left-white.right:before {
    background-position: -13px -21px;
    -webkit-transform: translate(-50%, -50%);
    transform: translate(-50%, -50%);
}

ul {
    display: block;
    -webkit-margin-before: 1em;
    -webkit-margin-after: 1em;
    -webkit-margin-start: 0;
    -webkit-margin-end: 0;
    list-style-type: inherit;
}

ol {
   list-style-type: decimal;
}

.onePanelManager .uiPanel.open.active {
    z-index: 10 !important;
}
.onePanelManager .forceModal.open.active {
    z-index: 10 !important;
}

.popupTargetContainer.uiPopupTarget.uiMenuList.uiMenuList--default.uiMenuList--left.visible{
    display:block  !important;
}

.article__content .article-anchor {
    display: block;
    position: relative;
    top: -70px;
    visibility: hidden;
}

.is-mobile .doc-nav__item-lvl-1.doc-nav__item-lvl-1--active:hover .doc-nav__link-lvl-1:after, .is-mobile .doc-nav__item-lvl-1.active:hover .doc-nav__link-lvl-1:after {
    border-top-color: #adb2bd ;
    -webkit-transform: rotate(0);
    transform: rotate(0);
    margin-top: 0;
    margin-right: 0;
}

@media only screen and (max-width: 992px) {
    .doc-nav__link-lvl-1:after {
        display: block;
        position: absolute;
        top: 21px;
        right: 11px;
        content: '';
        border: 5px solid transparent;
        border-top-color: #adb2bd;
        transition: all 0.3s ease;
        -webkit-transform-origin: 0 25%;
        transform-origin: 0 25%;
        -webkit-transform: rotate(-90deg);
        transform: rotate(-90deg);
        margin-top: 5px;
        margin-right: -5px;
    }
}

.doc-nav-arrow-mobile:after, .is-mobile .doc-nav__link-lvl-1:after, .is-mobile .doc-nav__link-lvl-2:after,
.is-mobile .doc-nav__item-lvl-1:hover .doc-nav__link-lvl-1:after {
    border-top-color: #adb2bd;
}

body .DESKTOP.uiContainerManager {
    display:none
}

.cBrAlgoliaSearchJSCMP .searchbox__input-text input {
    color: #4c4b58;
}
.serp__item-left-text {
    font-family: 'source_sans_proregular', Arial, sans-serif;
    font-size: 1.0rem;
}
.serp__item-title {
    font-size: 1rem;
    letter-spacing: .1px;
}
.serp__item-description {
    font-size: 0.85rem;
    line-height: 1.5rem;
    color: #5d5b66;
}
.slds-form-element__label {
    font-family: "Source Sans Pro","Helvetica Neue",Arial,sans-serif;
    color: #6d6e7a;
}
.slds-checkbox .slds-checkbox_faux, .slds-checkbox .slds-checkbox--faux {
    border-color: #d7d6d9;
}
.slds-radio .slds-radio_faux, .slds-radio .slds-radio--faux {
    border-color: #d7d6d9;
}
.filter__sub-title {
    font-family: 'source_sans_prosemibold', Arial, sans-serif;
    font-size: 0.85rem;
}
.slds-select {
    font-family: 'source_sans_proregular', Arial, sans-serif;
}
.slds-form-element__label {
    display: inherit;
}
.modal-overlay {
    background: rgba(215, 214, 217, 0.8);
}
.mobile-search-filter-is-active .serp__filter-trigger-icon:before {
    background-position: -778px -648px;
}

.slds-theme_info, .slds-theme--info {
    background-color: white;
}
/*TODO:should be at main styles
.forceToastMessage:before{
    content:url("https://bc-community-developer-edition.eu9.force.com/support/resource/1513953004000/BigcommerceCommunity/images/icon-alert-warning.png");
    content:url("../images/icon-alert-warning.png");
}
*/
.forceToastMessage{
    width:100%;
    border-radius: unset;
    margin: 0;
    min-height: 98px;
    padding: 15px;
}
.toastClose{
    color: #afb4be;
    width: 10px;
    height: 10px;
}
.toastClose:hover{
    color: #afb4be !important;
    box-shadow: none;
}
.toastClose:active{
    color: #afb4be !important;
    box-shadow: none;
}
.toastClose:focus{
    color: #afb4be !important;
    box-shadow: none;
}
.toastContent{
    padding-left: 30px;
}
.toastMessage{
    color: #4c4b58;
    letter-spacing: 0;
    font-family: 'source_sans_proregular', Arial, sans-serif;
    font-size: 0.9375rem;
    line-height: 1;
}
.toastTitle{
    display:none;
}
.article-area__content .article ul {
    padding-left: 40px
}
.anchor-margin:before {
    height: 70px;
    margin-top: -70px;
}
.mobile-menu-is-active .doc-nav__link-lvl-2--numeric:before {
    top: calc(50% - 10px);
}

.popupTargetContainer.uiPopupTarget.uiMenuList.uiMenuList--default.visible{
	display: block !important;
}
