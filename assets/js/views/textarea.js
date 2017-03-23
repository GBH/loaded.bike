export default function autoResizeTextArea(){
  const textareas = document.querySelectorAll('textarea[data-autoresize]')

  for (let textarea of textareas) {
    resizeTextArea(textarea)
    textarea.addEventListener('input', function(){
      resizeTextArea(this)
    })
  }
}

function resizeTextArea(textarea){
  textarea.style.height = textarea.scrollHeight + "px"
}