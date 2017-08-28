export default class MainView {
  mount(){
    $('[data-toggle="tooltip"]').tooltip()
    $('[data-toggle="dropdown"]').dropdown()
  }

  unmount(){
    // global view js goes here
  }
}
