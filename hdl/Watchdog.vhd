library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Watchdog is
  port (
    HeartBeat1    : in  std_logic;
    HeartBeat2    : in  std_logic;
    Clock         : in  std_logic;
    Initialize    : in  std_logic;
    Proc1_Enable  : out std_logic;
    Proc2_Enable  : out std_logic;
    Error         : out std_logic;
    Status        : out std_logic;
       HB1_LED       : out std_logic;
       BTN0 : out std_logic
  );
end Watchdog;

architecture Behaviour of Watchdog is
  -- Internal error/status signals
  signal status_int : std_logic := '0';
  signal error_int  : std_logic := '0';

  -- Error conditions for proc1 and proc2
  signal NoRiseErr1, NoFallErr1, BadRiseErr1 : std_logic := '0';
  signal NoRiseErr2, NoFallErr2, BadRiseErr2 : std_logic := '0';
  signal Fail1, Fail2                        : std_logic := '0';

  signal ActiveProc : std_logic := '0';
begin

  -- Instantiate the three counters for each heartbeat
  FallingTimeout1: entity work.CustomCounter
    generic map (EdgeType => '0')
    port map (Clock => Clock, Reset => HeartBeat1, TCnt => NoFallErr1);
  RisingTimeout1:  entity work.CustomCounter
    generic map (EdgeType => '1')
    port map (Clock => Clock, Reset => HeartBeat1, TCnt => NoRiseErr1);
  WindowCounter1:  entity work.CustomCounter
    generic map (OutputHL => '1')
    port map (Clock => Clock, Reset => HeartBeat1, TCnt => BadRiseErr1);

  FallingTimeout2: entity work.CustomCounter
    generic map (EdgeType => '0')
    port map (Clock => Clock, Reset => HeartBeat2, TCnt => NoFallErr2);
  RisingTimeout2:  entity work.CustomCounter
    generic map (EdgeType => '1')
    port map (Clock => Clock, Reset => HeartBeat2, TCnt => NoRiseErr2);
  WindowCounter2:  entity work.CustomCounter
    generic map (OutputHL => '1')
    port map (Clock => Clock, Reset => HeartBeat2, TCnt => BadRiseErr2);

  -- Combine error conditions
  Fail1 <= NoFallErr1 or NoRiseErr1 or BadRiseErr1;
  Fail2 <= NoFallErr2 or NoRiseErr2 or BadRiseErr2;

  -- Latch the overall status each clock
  process(Clock)
  begin
    if rising_edge(Clock) then
      -- Master status
      status_int <= Fail1 or Fail2;
    end if;
  end process;

  -- Latch a sticky error flag
  process(Clock)
  begin
    if rising_edge(Clock) then
      if Initialize = '1' then
        error_int <= '0';
      else
        error_int <= error_int or status_int;
      end if;
    end if;
  end process;

  -- Fail-over voting logic
  process(Clock)
  begin
    if rising_edge(Clock) then
      if Initialize = '1' then
        ActiveProc <= '0';    -- default to Proc1
      elsif Fail1 = '1' then
        ActiveProc <= '1';    -- switch to Proc2
      elsif Fail2 = '1' then
        ActiveProc <= '0';    -- switch back to Proc1
      end if;
    end if;
  end process;

  -- Drive outputs from the internal signals
  Proc1_Enable <= not ActiveProc;
  Proc2_Enable <=     ActiveProc;
  Status       <=     status_int;
  Error        <=     error_int;
    -- Mirror the raw heartbeat1 onto the HB1_LED port:
  HB1_LED <= HeartBeat1;
  BTN0 <= Initialize;

end Behaviour;
