// The `page` hatch on the web: a node marked hatch="page" hands this code its element. Yours to edit.
// What it gives up: nothing beyond the call. Leave the node's own box, position and children to Exact.
/** Built (`e.isNew`) and changed (a `data-*` word moved, in `e.data`). */
export function element(e) {
  if (e.isNew) {
    // Say what you add, bound to it, so the agent's tree shows whose it is:
    // e.owns(added, 'what it is and why');
    e.diagnostics.log(`built on <${e.element.localName}>`);
  }
}
/** The node is leaving: take back everything built added. */
export function elementEnded(e) {
}
