export default function formattingHelpToggle(){

  let showLink  = document.querySelector('a#show-formatting-help')
  let hideLink  = document.querySelector('a#hide-formatting-help')
  let table     = document.querySelector('table#formatting-help-table')

  showLink.addEventListener("click", function(e){
    e.preventDefault()
    showLink.style.display = "none"
    hideLink.style.display = "inline"
    table.style.display = "block"
  })

  hideLink.addEventListener("click", function(e){
    e.preventDefault()
    showLink.style.display = "inline"
    hideLink.style.display = "none"
    table.style.display = "none"
  })
}
