import Sortable from 'sortablejs';

export default {
    mounted() {
        let dragged; // this will change so we use `let`
        const hook = this;
        const selector = '#' + this.el.id;
        let dropzone = document.querySelector(".list-dropzone")
        console.log('List Drag Hook - The selector is:', selector);
        
        new Sortable(dropzone, {
            animation: 0,
            delay: 50,
            delayOnTouchOnly: true,
            // group: 'shared',
            draggable: '.list-draggable',
            ghostClass: 'sortable-ghost',
            onEnd: function (e) {
                const el = e.item
                const id = e.item.id
                const index = e.newDraggableIndex
                const list = this.toArray()

                let next = list[index + 1]
                let prev = list[index - 1]

                let position = null

                if (index == e.oldDraggableIndex) {
                    return
                } else if (prev != undefined && next == undefined) {
                    prev = parseFloat(prev)
                    position = prev + 1
                } else if (prev == undefined && next != undefined) {
                    next = parseFloat(next)
                    position = next - 1
                } else if (prev != undefined && next != undefined) {
                    prev = parseFloat(prev)
                    next = parseFloat(next)
                    position = (parseFloat(prev) + parseFloat(next)) / 2
                }

                if (position != null) {
                    position = position.toString()
                    hook.pushEvent('reorder', { id, position })
                }
            },
        });
    }
};