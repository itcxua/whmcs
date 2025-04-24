{include file='modules/servers/puqHetznerDatacenter/templates/header.tpl'}

<script type="text/javascript">
    function GetCharts(timeframe){
        var charts = $('#charts');
        charts.html('<img src="../modules/servers/puqHetznerDatacenter/loader.gif">');
        charts.load("../modules/servers/puqHetznerDatacenter/lib/ajax.php?serviceid={$kvm->service_id}&action=charts&timeframe="+timeframe);
    }
</script>
<div class="text-center">
    <a class="btn btn-default" onclick="GetCharts('hour')">{$kvm->lang['Last hour']}</a>
    <a class="btn btn-default" onclick="GetCharts('day')">{$kvm->lang['Last day']}</a>
    <a class="btn btn-default" onclick="GetCharts('week')">{$kvm->lang['Last week']}</a>
    <a class="btn btn-default" onclick="GetCharts('month')">{$kvm->lang['Last month']}</a>
    <a class="btn btn-default" onclick="GetCharts('year')">{$kvm->lang['Last year']}</a>
</div>
<hr>
<div id="charts">{$charts}</div>