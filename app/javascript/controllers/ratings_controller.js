import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    destroy() {
        const confirmDelete = confirm(
            "Are you sure you want to delete these selected ratings?"
        );

        if (!confirmDelete) {
            return;
        }

        const selectedRatingsIDs = Array.from(
            document.querySelectorAll('input[name="ratings[]"]:checked'),
            (checkbox) => checkbox.value
        )

        const csrfToken = document.querySelector('meta[name="csrf-token"]').content;
        const headers = {"X-CSRF-Token": csrfToken};

        fetch("/ratings/", {
            method: "DELETE",
            headers: headers,
            body: selectedRatingsIDs.join(",")
        }).then((response) => {
            if (response.ok) {
                response.text().then((html) => {
                    document.querySelector("div.ratings").innerHTML = html
                });
            } else {
                throw new Error("Something went wrong");
            }
        })
            .catch((error) => {
                console.log(error);
            });
    }

    selectAll(event) {
        const checkboxes = document.querySelectorAll('input[name="ratings[]"]')
        checkboxes.forEach((checkbox) => {
            checkbox.checked = event.target.checked;
        })
    }
}