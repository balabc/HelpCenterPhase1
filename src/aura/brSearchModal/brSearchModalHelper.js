({
    openModal: function(component, event) {
        document.body.classList.add('is-modal');
        component.set('v.stateSearchModal', true);
    },
    closeModal: function(component, event) {
        document.body.classList.remove('is-modal');
        component.set('v.stateSearchModal', false);
    },
    toggleModal: function(component, event) {
        !component.get('v.stateSearchModal')
            ? this.openModal(component, event)
            : this.closeModal(component, event);
    }
})