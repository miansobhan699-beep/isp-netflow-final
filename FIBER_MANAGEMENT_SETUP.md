# Fiber Management Module

Fiber Management is integrated into the existing NetFlow ISP dashboard and uses the existing Python/FastAPI adapter with a persistent SQLite database at `config/fiber_management.db`.

## Sidebar
Network → Fiber Management
- Fiber Mapping
- Fiber Cables
- Fiber Cores
- Joint / Splice Management
- Splitter Management
- Fiber Calculation
- Optical Power Budget
- Fiber Faults
- Fiber Reports

## Real data
The module does not generate fake optical measurements. Cable/core/splitter/fault/calculation records are stored in SQLite. Actual ONU RX can be entered from real OLT/ONU telemetry or a measured value and is kept separate from estimated RX.

## Fiber calculation
Total Optical Loss = fiber loss + splitter loss + splice loss + connector loss + other loss + safety margin.
Expected ONU RX = OLT TX - total optical loss.

Manufacturer-specific splitter/fiber/ONU values are configurable from Settings.

## Route budget
A saved route can contain cable, joint and splitter IDs. The route budget endpoint retrieves their stored lengths/losses and calculates the complete route budget.

## Reports
Fiber reports export the current database-backed records to CSV. CSV is directly importable into Excel. The browser print action can be used for PDF output from the report view.

## Roles
- Owner/Admin: full Fiber Management.
- Network Engineer: network + fiber + MikroTik + monitoring.
- Technician: fiber + monitoring view/operations.
- Billing Staff: no Fiber Management unless explicitly granted.
- Retail ISP: existing retail access remains unchanged.

Run `START_ADAPTER.bat` normally. No separate fiber worker is required; the module uses the existing adapter/API service.
