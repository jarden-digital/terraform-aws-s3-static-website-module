var config = () => {
  fetch("config.json")
  .then(response => response.json())
  .then(json => console.log(json));
}

config();

