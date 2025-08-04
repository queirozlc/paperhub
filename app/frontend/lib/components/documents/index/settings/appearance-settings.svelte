<script lang="ts">
  import {
    SettingsDialogContent,
    SettingsDialogGroup,
    SettingsDialogTitle,
  } from '$lib/components/ui/settings-dialog'
  import { Tabs, TabsTrigger } from '$lib/components/ui/tabs'
  import TabsList from '$lib/components/ui/tabs/tabs-list.svelte'
  import { setMode, userPrefersMode } from 'mode-watcher'
</script>

<SettingsDialogContent>
  <SettingsDialogGroup>
    <SettingsDialogTitle>Configurações de Aparência</SettingsDialogTitle>

    <div class="flex items-center justify-between">
      <div class="flex flex-col gap-1">
        <p class="text-sm font-brand font-medium">Tema</p>
        <p class="text-xs font-medium text-muted-foreground font-brand">
          Escolha o tema do seu workspace
        </p>
      </div>

      <Tabs value={userPrefersMode.current} onValueChange={setMode}>
        <TabsList>
          <TabsTrigger value="light">
            <span>Claro</span>
          </TabsTrigger>

          <TabsTrigger value="system">
            <span>Sistema</span>
          </TabsTrigger>
          <TabsTrigger value="dark">
            <span>Escuro</span>
          </TabsTrigger>
        </TabsList>
      </Tabs>
    </div>
  </SettingsDialogGroup>
</SettingsDialogContent>
