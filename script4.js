
/* LAN OLT adapter bridge: when the dashboard is opened as file://, route adapter API calls to the local monitoring service. */
if (!window.NETFLOW_ADAPTER_URL && location.protocol === 'file:') window.NETFLOW_ADAPTER_URL = 'http://127.0.0.1:8080';
