function submit() {

    var cardinalCollectionForm = document.querySelector('#cardinal_collection_form');
    if (cardinalCollectionForm) // form exists 
        cardinalCollectionForm.submit();
    var coloredDiv = document.getElementById("coloredDiv");
    coloredDiv.setAttribute('style', 'background:red');

    JavascriptChannel.postMessage('Hellp World from javascript');
}

function ok() {
    var coloredDiv = document.getElementById("coloredDiv");
    coloredDiv.setAttribute('style', 'background:orange');


}