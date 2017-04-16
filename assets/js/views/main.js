export default class MainView {
  mount(){
    $('[data-toggle="tooltip"]').tooltip()
    $('[data-toggle="dropdown"]').dropdown()

    // stupid shit to make signout work as bootstrap murders event
    $(".no-bootstrap").click(function(e) {
      e.stopPropagation()
      e.preventDefault()
      $(e.target).parent().submit()
    })
  }

  unmount(){
    // global view js goes here
  }
}
