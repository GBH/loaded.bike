import "phoenix_html"

import loadView from './views/loader';

function handleDOMContentLoaded(){

  // Get the current view name
  const viewName = document.getElementsByTagName('body')[0].dataset.pageIdentifier;

  // Load view class and mount it
  const ViewClass = loadView(viewName)
  const view = new ViewClass()
  view.mount()

  window.currentView = view
}

function handleDocumentUnload(){
  window.currentView.unmount()
}

window.addEventListener('DOMContentLoaded', handleDOMContentLoaded, false)
window.addEventListener('unload', handleDocumentUnload, false)