// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .

function updateCountdown() {
    var message = $('.message');
    if (message.length === 0) return;
    // 250 is the max message length
    var remaining = 250 - message.val().length;
    jQuery('.countdown').text(remaining);
}

jQuery(document).ready(function ($) {
    var message = $('.message');
    updateCountdown();
    message.change(updateCountdown);
    message.keyup(updateCountdown);

    var mentions = $('#micropost-input').data('url');
    if (mentions !== null) {
        mentions.push('alle - Hele gjengen');
        message.textcomplete([
            { // html
                match: /\B@(\S*)$/,
                search: function (term, callback) {
                    callback($.map(mentions, function (mention) {
                        return mention.match(new RegExp(term, "i")) ? mention : null;
                    }));
                },
                index: 1,
                replace: function (mention) {
                    return '@' + mention.split(' - ')[0] + ' ';
                }
            }
        ]);
    }

    // Event functionality
    $(".form_datetime").datetimepicker({
        format: "dd MM yyyy - hh:ii",
        autoclose: true,
        todayBtn: true,
        pickerPosition: "bottom-left"
    });

    $('.checkall').on('click', function () {
        $(this).closest('div#people-to-invite').find(':checkbox').prop('checked', this.checked);
    });

});




