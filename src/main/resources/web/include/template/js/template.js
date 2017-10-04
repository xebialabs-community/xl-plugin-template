/**
 *    Copyright 2017 XEBIALABS
 *
 *    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 *    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 *    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

String.prototype.format = function () {
  var args = arguments;
  return this.replace(/\{\{|\}\}|\{(\d+)\}/g, function (m, n) {
    if (m == "{{") { return "{"; }
    if (m == "}}") { return "}"; }
    return args[n];
  });
};

function loadVersions() {
    $.ajax({
    datatype: "json",
    url: "/api/extension/type-migrator/getVers?app=" + $("#applicationPath").find(':selected').val(),
    crossDomain: true,
    beforeSend: function(xhr) {
      var base64 = parent.getAuthToken();
      xhr.setRequestHeader("Authorization", base64);
    },
    success: function(data) {
      var verItems = [];
      $.each(data.entity, function(idx, val) {
              verItems.push("<option>" + val + "</option>")
      });
      $("#oldVerNum").empty().append(verItems);
    }
  })
}

function loadApplications() {
    $.ajax({
    datatype: "json",
    url: "/api/extension/type-migrator/getApps",
    crossDomain: true,
    beforeSend: function(xhr) {
      var base64 = parent.getAuthToken();
      xhr.setRequestHeader("Authorization", base64);
    },
    success: function(data) {
      var appItems = [];
      $.each(data.entity, function(idx, val) {
              appItems.push("<option>" + val + "</option>")
      });
      appItems.sort();
      $("#applicationPath").empty().append(appItems);
    }
  });
  loadVersions();
}

function migrateDeployables() {
  p1 = $('#obsoleteDeployableType').val();
  p2 = $('#applicationPath').val();
  p3 = $('#oldVerNum').val();
  p4 = $('#newVerNum').val();
  $.ajax({
    datatype: "json",
    url: "/api/extension/type-migrator/migrateDeployables?p1=" + p1 + "&p2=" + p2 + "&p3=" + p3 + "&p4=" + p4,
    crossDomain: true,
    beforeSend: function(xhr) {
      var base64 = parent.getAuthToken();
      xhr.setRequestHeader("Authorization", base64);
    },
    success: function(data) {
      message = "{0} {2}/{3}/{1} to {2}/{4}/{5}".format("Successfully migrated", p1, p2, p3, p4, data.entity);
      alert(message);
    },
    error: function(xhr, status, error) {
      alert(xhr.responseText);
    }
  });
}

function migrateDeployeds() {
  p1 = $('#obsoleteDeployedType').val();
  p2 = $('#parent').val();
  p3 = $('#ancestor').val();
  $.ajax({
    datatype: "json",
    url: "/api/extension/type-migrator/migrateDeployeds?p1=" + p1 + "&p2=" + p2 + "&p3=" + p3,
    crossDomain: true,
    beforeSend: function(xhr) {
      var base64 = parent.getAuthToken();
      xhr.setRequestHeader("Authorization", base64);
    },
    success: function(data) {
      message = "{0} {1} to {2}".format("Successfully migrated", p1, data.entity);
      alert(message);
    },
    error: function(xhr, status, error) {
      alert(xhr.responseText);
    }
  });
}

function refreshDeployables() {
    $("#obsoleteDeployableType").val("");
    $("#newVerNum").val("");
    loadApplications();
}

function refreshDeployeds() {
    $("#obsoleteDeployedType").val("");
    $("#parent").val("");
    $("#ancestor").val("");
}
