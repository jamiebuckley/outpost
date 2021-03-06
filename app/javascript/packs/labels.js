import "@yaireo/tagify/dist/tagify.polyfills.min.js"
import Tagify from "@yaireo/tagify"

let inputs = document.querySelectorAll("[data-labels]")

if(inputs){
    inputs.forEach(input => {
        let tagify = new Tagify(input , {
            whitelist: __LABELS__.map(label => label.name),
            originalInputValueFormat: valuesArr => valuesArr.map(item => item.value).join(',')
        })
    })
}

