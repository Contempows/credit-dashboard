// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require jquery_ujs
//= require dataTables/jquery.dataTables
//= require dataTables/bootstrap/3/jquery.dataTables.bootstrap
//= require dataTables/jquery.dataTables
//= require jquery.remotipart
//= require turbolinks
//= require select2-full
//= require bootstrap-datepicker/core
//= require bootstrap-datepicker/locales/bootstrap-datepicker.es.js
//= require dropzone.min
//= require jquery_nested_form
//= require_tree .

$(document).ready(function(){
  // $('select').select2({theme: 'bootstrap'});
  hideAlert();
});

$(document).on('ready turbolinks:load', function(){
  $('.data-error').on('click', function(){
    var text = $(this).attr('data-error');
    $('#index_errors').modal('show');
    $('.error-sub-title').html('');
    $('.error-sub-title').append(text);
    $('p.alert').show();
  });
});

function hideAlert() {
  window.setTimeout(function() {
    $(".alert-wrapper").fadeTo(500, 0).slideUp(500, function(){
      $(this).remove(); 
    });
  }, 2000);
}

function isNumber(evt) {
  evt = (evt) ? evt : window.event;
  var charCode = (evt.which) ? evt.which : evt.keyCode;
  return !(charCode > 31 && (charCode < 48 || charCode > 57));
}

function isFloatPress(eve) {
  target_id = eve.target.id
  id = '#' + target_id
  if ((eve.which != 46 || $(id).val().indexOf('.') != -1) && (eve.which < 48 || eve.which > 57) || (eve.which == 46 && $(id).caret().start == 0) ) {
    eve.preventDefault();
  }
}

function isFloatUp(eve) {
  target_id = eve.target.id
  id = '#' + target_id
  if($(id).val().indexOf('.') == 0) {
    $(id).val($(id).val().substring(1));
  }
}

function isRealUp(eve) {
  target_id = eve.target.id
  id = '#' + target_id
  if($(id).val().indexOf('.') == 0) {
    $(id).val($(id).val().substring(1));
  }
  if ($(id).val().indexOf('-') != 0) {
    eve.preventDefault();
  }
}

function isRealPress(eve) {
  target_id = eve.target.id
  id = '#' + target_id
  if ((eve.which != 46 && eve.which != 45 || $(id).val().indexOf('.') != -1) && (eve.which < 48 || eve.which > 57)) {
    eve.preventDefault();
  }
}


$(document).on('nested:fieldAdded', function(event) {
  changeNote(1);
});

$(document).on('nested:fieldRemoved', function(event){
  changeNote(-1);
});

function changeNote(count) {
  new_ssns += count;
  $('.note-ssns-charge').html(' You will be charged $' + Number(charge) * Number(new_ssns) + ' ($' + charge + '/number) for this purchase')
}

;(function () {

  $(document).ready(function () {

    var editableContainer = $('.js-editable-form');

    $('.date-of-birth, .datepicker').datepicker()

    $('.select-picker').each(function (i, el) {
      $(this).select2()
    })

    $('.js-with-placeholder').select2({
      placeholder: 'Select bank name'
    })

    $('.purchase-modal .js-with-placeholder').select2({
      placeholder: '---- Select ----'
    })

    $('.btn-edit').on('click', function() {

      $(this).text(function (i, text) {
        return text === 'Edit Profile' ? 'Update Profile' : 'Edit Profile'
      })

      editableContainer.each(function (el) {
        
        $(this).toggleClass('editable');
        $(this).find('input:disabled, textarea:disabled').each(function (el) {

          $(this).attr('disabled', false).attr('readonly', false);
          $(this).focus(function() {

            $(this).closest('.form-group').toggleClass('field-focused')
            $(this).closest('.profile-image-wrapper').toggleClass('field-focused')
          })
          .blur(function() {

            $(this).closest('.form-group').removeClass('field-focused')
            $(this).closest('.profile-image-wrapper').removeClass('field-focused')
          })
        })
      })
    })
  })

})();
