// configuration data for other SSDTs in this pack

#ifndef NO_DEFINITIONBLOCK
DefinitionBlock("", "SSDT", 2, "hack", "_RMCF", 0)
{
#endif
    Device(RMCF)
    {
        Name(_ADR, 0)   // do not remove

        Method(HELP)
        {
            Store("TYPE indicates type of the computer. 0: desktop, 1: laptop", Debug)
            Store("DPTS for laptops only. 1: enables/disables DGPU in _WAK/_PTS", Debug)
            Store("SHUT enables shutdown fix. bit 0: disables _PTS code when Arg0==5, bit 1: SLPE=0 when Arg0==5", Debug)
            Store("XPEE enables XHC.PMEE fix. 1: set XHC.PMEE to zero in _PTS when Arg0==5", Debug)
            Store("SSTF enables _SST LED fix. 1: enables _SI._SST in _WAK when Arg0 == 3", Debug)
            Store("AUDL indicates audio layout-id for patched AppleHDA. Ones: no injection", Debug)
        }

        // TYPE: Indicates the type of computer... desktop or laptop
        //
        //  0: desktop
        //  1: laptop
        Name(TYPE, 1)

        // DPTS: For laptops only: set to 1 if you want to enable and
        //  disable the DGPU _PTS and _WAK.
        //
        //  0: does not manipulate the DGPU in _WAK and _PTS
        //  1: disables the DGPU in _WAK and enables it in _PTS
        Name(DPTS, 0)

        // SHUT: Shutdown fix, disable _PTS code when Arg0==5 (shutdown)
        //
        //  0: does not affect _PTS behavior during shutdown
        //  bit 0 set: disables _PTS code during shutdown
        //  bit 1 set: sets SLPE to zero in _PTS during shutdown
        Name(SHUT, 0)

        // XPEE: XHC.PMEE fix, set XHC.PMEE=0 in _PTS when Arg0==5 (shutdown)
        // This fixes "auto restart" after shutdown when USB devices are plugged into XHC on
        // certain computers.
        //
        // 0: does not affect _PTS behavior during shutdown
        // 1: sets XHC.PMEE in _PTS code during shutdown
        Name(XPEE, 0)

        // SSTF: _SI._SST fix.  To fix LED on wake.  Useful for some Thinkpad laptops.
        //
        // 0: no effect during _WAK
        // 1: calls _SI._SST(1) during _WAK when Arg0 == 3 (waking from S3 sleep)
        Name(SSTF, 0)

        // AUDL: Audio Layout
        //
        // The value here will be used to inject layout-id for HDEF and HDAU
        // If set to Ones, no audio injection will be done.
        Name(AUDL, Ones)

        // DAUD: Digital audio
        //
        // 0: "hda-gfx" is disabled, injected as "#hda-gfx" instead
        // 1: (default when not specified) "hda-gfx" is injected
        Name(DAUD, 1)

        // DWOU: Disable wake on USB
        // 1: Disable wake on USB
        // 0: Do not disable wake on USB
        Name(DWOU, 1)
    }
#ifndef NO_DEFINITIONBLOCK
}
#endif
//EOF
