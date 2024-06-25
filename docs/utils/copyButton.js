function copy(elementID) {
    // Get the text field
    var copyText = document.getElementById(elementID);
  
    // Select the text field
    copyText.select();
  
     // Copy the text inside the text field
    navigator.clipboard.writeText(copyText.value);
  
}