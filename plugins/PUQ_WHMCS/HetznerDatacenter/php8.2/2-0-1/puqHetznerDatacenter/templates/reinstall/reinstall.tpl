{include file='modules/servers/puqHetznerDatacenter/templates/header.tpl'}

{if $message eq 'success'}
    <div class="alert alert-success text-center">{$kvm->lang['Reinstallation process started successfully']}</div>
{/if}
{if $message ne 'success' && $message ne ''}
    <div class="alert alert-danger text-center">{$message}</div>
{/if}
<br>
<br>
<script type="text/javascript">
    function Confirmation(){
        if(Confirmation_check()) {
            alert('{$kvm->lang['Reinstall?']}');
            if(confirm('{$kvm->lang['Are you sure?']}')) {
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }
</script>

<style>
.infobox {
  background-image: url(../../../assets/img/statuswarning.gif);
  background-repeat: no-repeat;
  background-position: 15px;
  margin: 10px 0;
  padding: 6px 10px 6px 60px;
  min-height: 28px;
  background-color: #faf6d4;
  border: 1px solid #e6c26e;
  color: #3b3b3b;
  text-align: left;
  -moz-border-radius: 5px;
  -webkit-border-radius: 5px;
  -o-border-radius: 5px;
  border-radius: 5px;
}
</style>

<script type="text/javascript">
    function applyTableStyles() {
        const table = document.querySelector('#imageDetails .datatable');
        if (table) {

            table.className = 'table table-list w-hidden dataTable no-footer';
            table.setAttribute('aria-describedby', 'tableDomainsList_info');
            table.setAttribute('role', 'grid');
            table.style.display = 'table';

            const thead = document.createElement('thead');
            const tbody = table.querySelector('tbody');
            const firstRow = tbody.querySelector('tr');
            const headerRow = document.createElement('tr');
            headerRow.setAttribute('role', 'row');

            firstRow.querySelectorAll('th').forEach((th, index) => {
                const newTh = document.createElement('th');
                newTh.className = index === 0 ? 'width-fixed-20 sorting_disabled' : 'sorting_disabled';
                newTh.setAttribute('rowspan', '1');
                newTh.setAttribute('colspan', '1');
                newTh.style.width = index === 0 ? '20px' : '0px';
                newTh.setAttribute('aria-label', '');
                newTh.innerHTML = th.innerHTML;
                headerRow.appendChild(newTh);
            });

            thead.appendChild(headerRow);
            // table.insertBefore(thead, tbody);
        }
    }

    document.addEventListener('DOMContentLoaded', () => {
        const targetNode = document.getElementById('imageDetails');
        if (targetNode) {
            const observer = new MutationObserver((mutations) => {
                mutations.forEach((mutation) => {
                    if (mutation.addedNodes.length || mutation.removedNodes.length) {
                        applyTableStyles();
                    }
                });
            });

            const config = { childList: true, subtree: true };
            observer.observe(targetNode, config);
        }
        applyTableStyles();
    });

    function Confirmation_check() {
        const isoTypeSelect = document.getElementById('isoTypeSelect');
        const isoImageSelect = document.getElementById('isoImageSelect');
        const protectInput = document.querySelector('input[name="protect"]');

        if (isoTypeSelect.value === "") {
            alert("{$kvm->lang['Please select an image type.']}");
            return false;
        }

        if (isoImageSelect.value === "") {
            alert("{$kvm->lang['Please select an image.']}");
            return false;
        }

        if (protectInput.value.trim() === "") {
            alert("{$kvm->lang['Please enter the protection word.']}");
            return false;
        }

        return true;
    }

    {if $kvm->allow_chose_backup_and_snapshot_when_reinstall_service != 'on'}
        document.addEventListener('DOMContentLoaded', () => {
            const showBackupsCheckbox = document.getElementById('showBackupsCheckbox');
            const showSnapshotsCheckbox = document.getElementById('showSnapshotsCheckbox');

            if (showBackupsCheckbox) {
                const showBackupsLabel = showBackupsCheckbox.closest('label');
                showBackupsCheckbox.style.display = 'none';
                if (showBackupsLabel) {
                    showBackupsLabel.style.display = 'none';
                }
            }

            if (showSnapshotsCheckbox) {
                const showSnapshotsLabel = showSnapshotsCheckbox.closest('label');
                showSnapshotsCheckbox.style.display = 'none';
                if (showSnapshotsLabel) {
                    showSnapshotsLabel.style.display = 'none';
                }
            }
        });
    {/if}
</script>


<div {$kvm->vm_local_status_html_inactive}>
    <form method="post" action="/clientarea.php?action=productdetails&id={$kvm->service_id}&action_m=reinstall">
        <div class="form-group text-center">
            <h2>{$kvm->lang['You are in the area of reinstalling the virtual machine.']}</h2>
            <h3>{$kvm->lang['You must be aware of what you will do here.']}</h3>
            <h3 style="color: red">{$kvm->lang['Reinstalling the virtual machine, completely remove all data on all disks of the virtual machine.']}</h3>
            <b>{$kvm->lang['First select your operating system type and then select your image.']}</b>
            {if $kvm->allow_chose_backup_and_snapshot_when_reinstall_service == 'on'}
                <b>{$kvm->lang['Please note that you can deploy backups of your other machines.']}</b>
            {/if}
            <input type="hidden" id="architecture_input" name="architecture" value='{$architecture}'>
            <input type="hidden" id="os" name="os" value='{$os}'>
            {$kvm->generateIsoSelectionForm('os')}
            <H4>{$kvm->lang['To protect against accidental reinstallation.']}</h4>
            <h4> {$kvm->lang['Please enter the word:']} <b style="color: red">reinstall</b> {$kvm->lang['In capital letters.']}</H4>
            <input type="input" name="protect" class="form-control"/>
            <BR>
            <button onclick="return Confirmation();" type="submit" class="btn btn-success"><i class="fa fa-retweet">&nbsp;</i>{$kvm->lang['Reinstall']}</button>
        </div>
    </form>
</div>

