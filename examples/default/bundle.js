var getConfig = () => {
  fetch("config.json")
  .then(response => response.json())
  .then(json => appendJsonData(json))
};

var appendJsonData = (data) => {
  Object.keys(data).forEach((key) => {
    console.log(key, data[key])
    var block = document.querySelector("div.target")
    var p = document.createElement('p')
    p.innerHTML = key + ': '+ data[key]
    block.appendChild(p)
  })
}

getConfig();