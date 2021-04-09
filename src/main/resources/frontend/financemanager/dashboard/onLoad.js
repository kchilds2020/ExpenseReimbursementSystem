var reimbData = null;
window.onload = async (e) => {
    e.preventDefault();

    //get all reimbursements based on session
    overlayOn();
    let response = await fetch("http://localhost:9001/api/get/reimbursements");
    const data = await response.json();
    overlayOff();

    //set global variable reimbdata
    reimbData = data;

    //populate all rows in the table
    let table = document.getElementById("reimb-table").getElementsByTagName('tbody')[0];
    popRows(data, table);
     

}

//add color to text for status
function getStatusForHTML(status, id){
    if(status === "PENDING")
        return `<span id="status${id}" class = "pending-status">${status}</span>`
    else if(status === "APPROVED")
        return `<span id="status${id}" class = "approved-status">${status}</span>`
    else if(status === "DENIED")
        return `<span id="status${id}" class = "denied-status">${status}</span>`
}

//download file functionality
async function downloadReceipt(e){
    const res = await fetch(`http://localhost:9001/api/get/reimbursements/id/${e.target.id.slice(12)}`)
  
    const reimbursement = await res.json();
  
    //convert string to binary string
    var binaryString = window.atob(reimbursement.receipt);
    var binaryLen = binaryString.length;
    var bytes = new Uint8Array(binaryLen);
    for (var i = 0; i < binaryLen; i++) {
       var ascii = binaryString.charCodeAt(i);
       bytes[i] = ascii;
    }
    //create pdf blob and download
    var blob = new Blob([bytes], {type: "application/pdf"});
    var link = document.createElement('a');
    link.href = window.URL.createObjectURL(blob);
    var fileName = `ReceiptID${reimbursement.id}`;
    link.download = fileName;
    link.click();
  
  }


  //dom manipulation of table
  function popRows(data, table){
    data.forEach((element,index) => {
        let row = table.insertRow();
        row.classList.add("table-light");
        let col1 = row.insertCell(0);
        let col2 = row.insertCell(1);
        let col3 = row.insertCell(2);
        let col4 = row.insertCell(3);
        let col5 = row.insertCell(4);
        let col6 = row.insertCell(5);
        let col7 = row.insertCell(6);
        let col8 = row.insertCell(7);
        let col9 = row.insertCell(8);
        let col10 = row.insertCell(9);
        if(element.status.value === "PENDING"){
            col9.innerHTML = `
            <span style="color: green;">
                <i class="fas fa-check" id = "approveBtn${element.id}" onclick = "approveReimb(event)"></i>
            </span>`
            col10.innerHTML = `
            <span style="color: tomato;">
                <i class="far fa-times-circle" color="red" id = "denyBtn${element.id}" onclick = "denyReimb(event)"></i>
            </span>`
     }
        if(element.receipt)
          col2.innerHTML = `<i class="fas fa-file-pdf" id = "btn-receipt-${element.id}" onclick="downloadReceipt(event)"></i>`;

        col1.innerHTML = "<b>" + element.id + "</b>";
        col3.innerHTML = "$" +element.amount;
        col4.innerHTML = element.description;
        col5.innerHTML = element.author.username;
        col6.innerHTML = element.type.value;
        col7.innerHTML = getStatusForHTML(element.status.value, element.id);
        col8.innerHTML = element.dateSubmitted;

    });
  }

  //filter table when checkbox is clicked
  const toggleFilter = () => {
    let filterCheck = document.getElementById("flexCheckDefault")
    var old_tbody = document.getElementById("reimb-table").getElementsByTagName('tbody')[0];
    var new_tbody = document.createElement('tbody');
    if(filterCheck.checked){
        let filtered = reimbData.filter((element) => element.status.value === "PENDING")
        popRows(filtered,new_tbody) 
        
    }else{
        popRows(reimbData,new_tbody)
    }
    old_tbody.parentNode.replaceChild(new_tbody, old_tbody)
  }