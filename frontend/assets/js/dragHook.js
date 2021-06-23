import Sortable from 'sortablejs';

export default {
    mounted() {
        let dragged; // this will change so we use `let`
        const hook = this;
        const selector = '#' + this.el.id;
        console.log('The selector is:', selector);
        
        // make sure you prepend the class's name with a period "." to indicate it's a class
        document.querySelectorAll('.dropzone').forEach((dropzone) => {
            new Sortable(dropzone, {
                animation: 0,
                delay: 50,
                delayOnTouchOnly: true,
                group: 'shared',
                draggable: '.draggable',
                ghostClass: 'sortable-ghost',
                onEnd: function (evt) {
                    hook.pushEventTo(selector, 'dropped', {
                        draggedId: evt.item.id, // id of the dragged item
                        dropzoneId: evt.to.id, // id of the drop zone where the drop occured
                        draggableIndex: evt.newDraggableIndex, // index where the item was dropped (relative to other items in the drop zone)
                    });
                },
            });
        });
    }
};