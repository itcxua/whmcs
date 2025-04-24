{include file='modules/servers/puqHetznerDatacenter/templates/header.tpl'}

{if $message eq 'success'}
    <div class="alert alert-success text-center">{$kvm->lang['Successfully']}</div>
{/if}
{if $message ne 'success' && $message ne ''}
    <div class="alert alert-danger text-center">{$message}</div>
{/if}
<h2>{$kvm->lang['Reverse DNS record']}</h2>
<i class="fa fa-info">&nbsp;</i><i>{$kvm->lang['Changing a DNS record does not happen instantly. For a DNS record to work properly, it takes between 1 and 8 hours for the DNS servers to synchronize the record']}</i>
<br>
<hr>
<div {$kvm->vm_local_status_html_inactive}>
    <div class="text-center">
        <form method="post" action="/clientarea.php?action=productdetails&id={$kvm->service_id}&action_m=revdns_configure">
            <table class="table table-list dataTable no-footer">
                {foreach $kvm->vm_local_revdns as $ip => $revdns}
                    <tr>
                        <td style="text-align: right"><b>{$ip}</b></td>
                        <td><input type="text" name="revdns[{$ip|replace:".":"-"|replace:":":"_"}]" class="form-control input-200 input-inline" value="{$revdns}"/></td>
                    </tr>
                {/foreach}
            </table>
            <button onclick="return Confirmation();" type="submit" class="btn btn-success"><i class="fa fa-globe">&nbsp;</i>{$kvm->lang['Save']}</button>
        </form>
    </div>
</div>
<hr>