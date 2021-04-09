
const approveReimb = async (e) => {
    e.preventDefault();
    let reimbId = e.target.id.slice(10);

    /* get user object */
    overlayOn();
    const res = await fetch('http://localhost:9001/api/get/users/check-session');

    const user = await res.json();

    const response = await fetch(`http://localhost:9001/api/put/reimbursements/approve/${user.id}/${reimbId}`, {
        method: 'PUT',
        headers: {
          'Content-Type': 'application/json'
        },

      });
    overlayOff();

    /* update table after approval */
    reimbData.forEach(element => {
      if(element.id == reimbId){
        element.status.id = 2;
        element.status.value = "APPROVED";
      }
    });

    var old_tbody = document.getElementById("reimb-table").getElementsByTagName('tbody')[0];
    var new_tbody = document.createElement('tbody');
    popRows(reimbData, new_tbody);
    old_tbody.parentNode.replaceChild(new_tbody, old_tbody)
}