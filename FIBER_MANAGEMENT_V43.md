# Fiber Management V43

Fiber Management is integrated into **Network** and uses the existing adapter architecture.

## Modules
- Fiber Mapping
- Fiber Cables
- Fiber Cores
- Joint / Splice Management
- Splitter Management
- Fiber Calculation
- Optical Power Budget
- Fiber Faults
- Fiber Reports

## Data
Persistent SQLite database: `config/fiber_management.db`.

## Optical budget
- Fiber loss = length × configurable dB/km
- Splice loss = count × configurable splice loss
- Connector loss = count × configurable connector loss
- Splitter loss = sum of route splitter losses
- Total loss = all losses + other loss + safety margin
- Expected RX = OLT TX − total loss

Estimated and actual optical measurements are kept separate. Actual RX is stored only when a measured reading is supplied by telemetry or entered by an authorized user.

## Security
Owner/Admin have full Fiber access. Network Engineer has full network/fiber access. Technician has route/budget/fault access. Billing staff does not receive Fiber permissions unless explicitly granted through the existing permission system.
