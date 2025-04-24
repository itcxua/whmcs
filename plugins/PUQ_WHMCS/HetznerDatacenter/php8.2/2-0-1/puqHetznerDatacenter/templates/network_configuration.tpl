{* <h5>{$kvm->lang['Network configuration']}</h5>
{if $kvm->service_count_ipv4 ne '0'}
    <div class="form-group" style="text-align: left;">
        {if $kvm->package_options['network_configuration']['dhcp_ipv4'] ne 'on'}
            <div>
                <i class="fa fa-network-wired fa-1x"></i><b> IPv4: {$server_info.public_net.ipv4.ip} ({$kvm->service_domain})</b>
            </div>
            <table class="table table-list dataTable no-footer">
                <tr>
                    <td><b>{$kvm->lang['IP']}</b></td>
                    <td>
                        {$server_info.public_net.ipv4.ip}
                    </td>
                </tr>
                <tr>
                    <td><b>{$kvm->lang['DNS PTR']}</b></td>
                    <td>
                        {$server_info.public_net.ipv4.dns_ptr}
                    </td>
                </tr>
            </table>
        {else}
            <div>
                <i class="fa fa-network-wired fa-1x"></i><b> IPv4: DHCP</b>
            </div>
        {/if}
    </div>
{/if}

{if $kvm->service_count_ipv6 ne '0'}
    <div class="form-group" style="text-align: left;">
        {if $kvm->package_options['network_configuration']['dhcp_ipv6'] ne 'on'}
            <div>
                <i class="fa fa-network-wired fa-1x"></i><b> IPv6: {$server_info.public_net.ipv6.ip} ({$kvm->service_domain})</b>
            </div>
            <table class="table table-list dataTable no-footer">
                <tr>
                    <td><b>{$kvm->lang['IP']}</b></td>
                    <td>
                        {$server_info.public_net.ipv6.ip}
                    </td>
                </tr>
            </table>
        {else}
            <div>
                <i class="fa fa-network-wired fa-1x"></i><b> IPv6: DHCP</b>
            </div>
        {/if}
    </div>
{/if} *}