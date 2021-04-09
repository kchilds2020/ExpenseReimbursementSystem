
const denyReimb = async (e) => {
    e.preventDefault();
    let reimbId = e.target.id.slice(7);
    console.log(reimbId)

    let token = localStorage.getItem('token');

    /* Get User Object */
    overlayOn();
    const res = await fetch('http://localhost:9001/api/get/users/check-session',{
        headers:{
            'token': token
        }
    });

    const user = await res.json();

    /* deny reimbursement given rimbursement and user id */
    const response = await fetch(`http://localhost:9001/api/put/reimbursements/deny/${user.id}/${reimbId}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },

      });

    const data = await response.json();
    overlayOff();

    /* after successful, update table */
    reimbData.forEach(element => {
      if(element.id == reimbId){
        element.status.id = 3;
        element.status.value = "DENIED";
      }
    });

    var old_tbody = document.getElementById("reimb-table").getElementsByTagName('tbody')[0];
    var new_tbody = document.createElement('tbody');
    popRows(reimbData, new_tbody);
    old_tbody.parentNode.replaceChild(new_tbody, old_tbody)
    
}