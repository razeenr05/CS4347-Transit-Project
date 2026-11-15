/**
 * City Transit & Fleet Maintenance Hub — client-side validation (Phase 3 Task B)
 * Preview only: forms do not write to a database.
 */

function clearError(el) {
  var existing = el.parentElement.querySelector(".error");
  if (existing) {
    existing.remove();
  }
}

function showError(el, message) {
  clearError(el);
  var err = document.createElement("div");
  err.className = "error";
  err.textContent = message;
  el.parentElement.appendChild(err);
}

/**
 * Trip Scheduling: arrival time must be after departure time (same date).
 */
function validateTripTimes(form) {
  var dep = form.querySelector('[name="scheduled_departure"]');
  var arr = form.querySelector('[name="scheduled_arrival"]');
  if (!dep || !arr) {
    return true;
  }
  clearError(arr);
  if (!dep.value || !arr.value) {
    return true;
  }
  if (arr.value <= dep.value) {
    showError(arr, "Arrival time must be after departure time.");
    arr.focus();
    return false;
  }
  return true;
}

/**
 * Maintenance: completed orders require a completion date.
 * Repair cost, if provided, must be nonnegative (also enforced by HTML min).
 */
function validateMaintenance(form) {
  var status = form.querySelector('[name="status"]');
  var completion = form.querySelector('[name="completion_date"]');
  var cost = form.querySelector('[name="repair_cost"]');
  var ok = true;

  if (completion) {
    clearError(completion);
  }
  if (cost) {
    clearError(cost);
  }

  if (status && completion && status.value === "Completed") {
    if (!completion.value) {
      showError(completion, "A completion date is required when status is Completed.");
      completion.focus();
      ok = false;
    }
  }

  if (cost && cost.value !== "" && Number(cost.value) < 0) {
    showError(cost, "Repair cost must be nonnegative.");
    if (ok) {
      cost.focus();
    }
    ok = false;
  }

  return ok;
}

/**
 * Vehicle: mileage must be nonnegative (also enforced by HTML min).
 */
function validateVehicle(form) {
  var mileage = form.querySelector('[name="mileage"]');
  if (!mileage) {
    return true;
  }
  clearError(mileage);
  if (mileage.value !== "" && Number(mileage.value) < 0) {
    showError(mileage, "Mileage must be nonnegative.");
    mileage.focus();
    return false;
  }
  return true;
}

document.addEventListener("DOMContentLoaded", function () {
  var tripForm = document.getElementById("trip-form");
  if (tripForm) {
    tripForm.addEventListener("submit", function (e) {
      if (!validateTripTimes(tripForm)) {
        e.preventDefault();
      }
    });
  }

  var maintForm = document.getElementById("maintenance-form");
  if (maintForm) {
    maintForm.addEventListener("submit", function (e) {
      if (!validateMaintenance(maintForm)) {
        e.preventDefault();
      }
    });
  }

  var vehicleForm = document.getElementById("vehicle-form");
  if (vehicleForm) {
    vehicleForm.addEventListener("submit", function (e) {
      if (!validateVehicle(vehicleForm)) {
        e.preventDefault();
      }
    });
  }
});
