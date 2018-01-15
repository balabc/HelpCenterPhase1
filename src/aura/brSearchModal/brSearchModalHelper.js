({
    openModal: function(component, event) {
        //console.log('[DEBUG] [Helper] brSearchModal:openModal');
        document.body.classList.add('is-modal');
        component.set('v.stateSearchModal', true);
    },
    closeModal: function(component, event) {
        //console.log('[DEBUG] [Helper] brSearchModal:closeModal');
        document.body.classList.remove('is-modal');
        component.set('v.stateSearchModal', false);
    },
    toggleModal: function(component, event) {
        //console.log('[DEBUG] [Helper] brSearchModal:toggleSearchModal');
        !component.get('v.stateSearchModal')
            ? this.openModal(component, event)
            : this.closeModal(component, event);
    }
})