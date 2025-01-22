const apiButton = document.getElementById("apiButton");
const dbapiButton = document.getElementById("dbapiButton");
const clearButton = document.getElementById("clearButton");
const apiResponse = document.getElementById("apiResponse");
const apiIp = "APIIPADDRESS"


apiButton.addEventListener("click", () => {
    fetch(`http://${apiIp}:8080/testapi`)
        .then(response => {
            if (!response.ok) {
                throw new Error("Network response was not ok");
              }
              return response.json();
        })
        .then(data => apiResponse.textContent = data.name)
        .catch(error => apiResponse.textContent = error.name);
});

dbapiButton.addEventListener("click", () => {
    fetch(`http://${apiIp}:8080/dbapi`)
        .then(response =>{
            if (!response.ok) {
                throw new Error("Network response was not ok");
              }
              return response.json();
        })
        .then(data => {
            if (Array.isArray(data) && data.length > 0) {
                apiResponse.textContent = data.map(item => item.name).join(", "); // 全要素の name を表示
            } else {
                apiResponse.textContent = "No data found";
            }

            })
        .catch(error => apiResponse.textContent = error.name);
});

clearButton.addEventListener("click", () => {
    apiResponse.textContent = "";
});
