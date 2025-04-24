{include file='modules/servers/puqHetznerDatacenter/templates/header.tpl'}
<style>

    .icon-wrapper {
        transition: all 0.3s ease-in-out;
    }

    .icon-wrapper:hover i {
        transition: all 0.3s ease-in-out;

        transform: scale(1.5);
        cursor: pointer;
    }

    .icon-wrapper i {
        font-size: 50px;
        color: #333;
        margin-bottom: 10px;
    }

    .icon-wrapper a {
        text-decoration: none;
        color: #333;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;

    }

</style>
<script type="text/javascript">
    function ButtonNovnc(){
        var button_body = $('#button_body');
        button_body.html('<img src="../modules/servers/puqHetznerDatacenter/loader.gif">');
        button_body.load("../modules/servers/puqHetznerDatacenter/lib/ajax.php?serviceid={$kvm->service_id}&action=novnc");
        setTimeout(() => ButtonReturn(), 10000);
    }
    function ButtonReturn() {
        var button_body = $('#button_body');
        button_body.html('');
    }

    function ButtonStart(){
        var button_body = $('#button_body');
        button_body.html('<img src="../modules/servers/puqHetznerDatacenter/loader.gif">');
        button_body.load("../modules/servers/puqHetznerDatacenter/lib/ajax.php?serviceid={$kvm->service_id}&action=start");
    }
    function ButtonStop(){
        var button_body = $('#button_body');
        alert('{$kvm->lang['Stop?']}');
        result = confirm('{$kvm->lang['Are you sure?']}');
        if (result) {
            button_body.load("../modules/servers/puqHetznerDatacenter/lib/ajax.php?serviceid={$kvm->service_id}&action=stop");
            button_body.html('<img src="../modules/servers/puqHetznerDatacenter/loader.gif">');
        }
    }

    function VmInfo(){
        var vm_info = $('#vm_info');
        vm_info.load("../modules/servers/puqHetznerDatacenter/lib/ajax.php?serviceid={$kvm->service_id}&action=informationonrealtime");
    }
    function VmInfoLoading(t){
        var vm_info_loading = $('#vm_info_loading');
        vm_info_loading.html("Reload..." + t);
    }
    function VmInfoLoadingImg(){
        var vm_info_loading = $('#vm_info_loading');
        vm_info_loading.html('<img src="../modules/servers/puqHetznerDatacenter/loader.gif">');
    }
    $(document).ready(function() {
                VmInfo();
                setInterval(VmInfo, 60000);
            });
</script>

<div id="button_body"></div>

<style>
        .hostbtn {
            width: 150px;
            min-width: 150px;
            padding: 10px 15px;
            background: #eee;
            display: inline-block;
            margin: 5px;
            vertical-align: top;
            border-radius: 3px;
            font-weight: 600;
            text-align: center;
            font-size: 14px;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .hostbtn i {
            margin-right: 0;
            display: block;
            font-size: 24px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: transform 0.2s;
        }

        .hostbtn:hover {
            background: #dbdbdb;
        }

        .hostbtn:hover i {
            transform: scale(1.2); /* Enlarge icon on hover */
        }
</style>

{* 
<hr> *}

<div {$kvm->vm_local_status_html_inactive}>
    <div class="row justify-content-center">

        <div class="col-6 col-xl-3 col-sm-3 col-xs-6 icon-wrapper" {$kvm->cc_allow_start_inactive} style="text-align: center;">
            <a onclick="ButtonStart()" style="background-color: #00000000; margin-right: 1px;">
                <i class="fa fa-power-off" style="color: green;"></i>
                <br>
                {$kvm->lang['Start']}
            </a>
        </div>


        <div class="col-6 col-xl-3 col-sm-3 col-xs-6 icon-wrapper" {$kvm->cc_allow_stop_inactive} style="text-align: center;">
            <a onclick="ButtonStop()" style="background-color: #00000000; margin-right: 1px;">
                <i class="fa fa-power-off" style="color: red;"></i>
                <br>
                {$kvm->lang['Stop']}
            </a>
        </div>

        <div class="col-6 col-xl-3 col-sm-3 col-xs-6 icon-wrapper" {$kvm->cc_allow_noVLC_inactive} style="text-align: center;">
            <a onclick="ButtonNovnc()" style="background-color: #00000000; margin-right: 1px;">
                <i class="fa fa-desktop" style="color: blue;"></i>
                <br>
                {$kvm->lang['noVNC']}
            </a>
        </div>

        <div class="col-6 col-xl-3 col-sm-3 col-xs-6 icon-wrapper" {$kvm->cc_allow_charts_inactive} style="border-right: 0 solid #ccc;">
            <a onclick="document.location.href = 'clientarea.php?action=productdetails&id={$kvm->service_id}&action_m=charts';" style="background-color: #00000000;">
                <i class="fa fa-chart-line" style="color: orange;"></i>
                <br>
                {$kvm->lang['Charts']}
            </a>
        </div>

    </div>
</div>

{* <div id="vm_info_loading" class="vm_info_loading"><img src="../modules/servers/puqHetznerDatacenter/loader.gif"></div> *}
<div id="vm_info">{$real_time}</div>

{* {include file='modules/servers/puqHetznerDatacenter/templates/network_configuration.tpl'} *}



{* <pre>
{$params['configoptions']|print_r}
</pre> *}



<div {$kvm->vm_local_status_html_inactive}>
    <div class="row justify-content-center" style="margin-right: -25px; margin-left: -25px;">
        <div class="d-flex justify-content-center flex-wrap">

            {if $kvm->package_options_link_to_instruction ne ""}
                <a href="{$kvm->package_options_link_to_instruction}" target="_blank" class="hostbtn">
                    <i class="fas fa-book status-icon orange" style="color: purple;"></i>
                    <br>
                    {$kvm->lang['User manual']}
                </a>
            {/if}

            <a onclick="window.open('http://{$server_info.public_net.ipv4.dns_ptr}', '_blank');" class="hostbtn" {$kvm->cc_allow_open_ptr_record_inactive}>
                <i class="fa fa-globe" style="color: purple;"></i>
                <br>
                {$kvm->lang['Open PTR Record']}
            </a>

            <a onclick="document.location.href = 'clientarea.php?action=productdetails&id={$kvm->service_id}&action_m=reinstall';" class="hostbtn" {$kvm->cc_allow_reinstall_inactive}>
                <i class="fa fa-retweet" style="color: purple;"></i>
                <br>
                {$kvm->lang['Reinstall']}
            </a>

            <a onclick="document.location.href = 'clientarea.php?action=productdetails&id={$kvm->service_id}&action_m=snapshots';" class="hostbtn" {$kvm->cc_snapshots_inactive}>
                <i class="fa fa-reply" style="color: purple;"></i>
                <br>
                {$kvm->lang['Snapshots']}
            </a>

            <a style="cursor: pointer;" onclick="document.location.href = 'clientarea.php?action=productdetails&id={$kvm->service_id}&action_m=backups';" class="hostbtn" {$kvm->cc_backups_inactive}>
                <i class="fa fa-reply-all" style="color: purple;"></i>
                <br>
                {$kvm->lang['Backups']}
            </a>

            <a onclick="document.location.href = 'clientarea.php?action=productdetails&id={$kvm->service_id}&action_m=reset_password';" class="hostbtn" {$kvm->cc_allow_reset_password_inactive}>
                <i class="fa fa-id-card" style="color: purple;"></i>
                <br>
                {$kvm->lang['Reset password']}
            </a>

            <a onclick="document.location.href = 'clientarea.php?action=productdetails&id={$kvm->service_id}&action_m=iso_mount';" class="hostbtn" {$kvm->cc_allow_iso_mount_inactive}>
                <i class="fa fa-dot-circle" style="color: purple;"></i>
                <br>
                {$kvm->lang['ISO mount']}
            </a>


            {* <a onclick="document.location.href = 'clientarea.php?action=productdetails&id={$kvm->service_id}&action_m=revdns_configure';" class="hostbtn" {$kvm->cc_allow_revdns_configure_inactive}>
                <i class="fa fa-globe" style="color: purple;"></i>
                <br>
                {$kvm->lang['revDNS']}
            </a> *}

            {* <a onclick="document.location.href = 'clientarea.php?action=productdetails&id={$kvm->service_id}&action_m=iso_mount';" class="hostbtn" {$kvm->cc_allow_iso_mount_inactive}>
                <i class="fa fa-dot-circle" style="color: purple;"></i>
                <br>
                {$kvm->lang['ISO']}
            </a> *}
        </div>
    </div>
</div>