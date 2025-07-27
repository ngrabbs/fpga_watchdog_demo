library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity CustomCounter is
  generic (
    Count        : integer := 5;    -- number of clock cycles
    EdgeType     : std_logic := '1';-- '1': rising‐edge reset, '0': falling‐edge reset
    CounterDrive : std_logic := '1';-- '1': count on rising clk,  '0': on falling clk
    OutputHL     : std_logic := '1';-- '0': active‐high tcnt, '1': active‐low tcnt
    TCntDur      : integer := 5     -- duration tcnt asserted (cycles)
  );
  port (
    Clock : in  std_logic;
    Reset : in  std_logic;
    TCnt  : out std_logic
  );
end CustomCounter;

architecture Behaviour of CustomCounter is
  signal InternalCount : integer := 0;
  signal AssertTime    : integer := 0;
  signal TCntInt       : std_logic := OutputHL;
begin
  -- Counting process
  process (Clock, Reset)
  begin
    if (Reset = EdgeType) then
      InternalCount <= 0;
      AssertTime    <= TCntDur;
    elsif ((CounterDrive = '1' and rising_edge(Clock)) or
          (CounterDrive = '0' and falling_edge(Clock))) then
      if InternalCount < Count then
        InternalCount <= InternalCount + 1;
      end if;
      if AssertTime > 0 then
        AssertTime <= AssertTime - 1;
        TCntInt    <= not OutputHL;
      else
        TCntInt    <= OutputHL;
      end if;
    end if;
  end process;
  TCnt <= TCntInt;
end Behaviour;
