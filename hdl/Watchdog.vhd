library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
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
    Status        : out std_logic
  );
end Watchdog;

architecture Behaviour of Watchdog is
  signal NoRiseErr1, NoFallErr1, BadRiseErr1 : std_logic := '0';
  signal NoRiseErr2, NoFallErr2, BadRiseErr2 : std_logic := '0';
  signal Fail1, Fail2                        : std_logic;
  signal ActiveProc                          : std_logic := '0';
begin
  -- Instantiate three counters for each processor
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

  -- Error flags
  Fail1 <= BadRiseErr1 or NoRiseErr1 or NoFallErr1;
  Fail2 <= BadRiseErr2 or NoRiseErr2 or NoFallErr2;

  -- Voting logic & failover
  process (Clock)
  begin
    if rising_edge(Clock) then
      if Initialize = '1' then
        ActiveProc <= '0';  -- default to processor 1
      elsif Fail1 = '1' then
        ActiveProc <= '1';  -- switch to 2
      elsif Fail2 = '1' then
        ActiveProc <= '0';  -- switch to 1
      end if;
    end if;
  end process;

  Proc1_Enable <= not ActiveProc;
  Proc2_Enable <= ActiveProc;
  Status       <= Fail1 or Fail2;
  Error        <= Error or Status;
end Behaviour;
