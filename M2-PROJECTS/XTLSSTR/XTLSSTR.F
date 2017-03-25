       Program xtlsstr

*     Version 1.3.9, 28 Sep 2001
*
*     Written by Sonya M. King and W. Curtis Johnson
*                Biochem/Biophys, Oregon State University, Corvallis OR 97331

*     This program is written in Fortran 77 for a Silicon Graphics
*  and calculates five measurements from the coordinates provided by the files
*  from the Protein Data Bank (pdb) in Brookhaven.  It loops through the
*  multiple structures in NMR data, and will handle up to 1000 atoms per
*  subunit and 10 subunits as now dimensioned.  It uses these measurements to
*  identify protein structure that is alpha helix, 3-10 helix, beta strand,
*  hydrogen bonded beta turn, nonhydrogen bonded beta turn, and polyproline II
*  type (3-1) helix.  Structure is determined on an amide
*  basis, and the amide index is the residue that contributes the carbonyl
*  group, -ie amide i, i+1 is associated with residue i.

*  In this version the 3-1 structure uses the Sreerama and Woody definition that
*  identifies the amino acids between the amides in the helix. Counting the ends
*  as 0.5 and the center as 1.0 gives the best correlation with CD.  All the Ps
*  are determined in the main loop to put the line output in order.

*  In this version the residues are renumbered starting with '1'.  This solves
*  many problems with the way pdb files can be numbered, but still leaves one
*  problem.  If residues have been skipped, then secondary structure will be
*  determined as if there is no gap.  Even this will not usually cause a
*  problem.  The original program, xtlsstr3, which does not renumber the
*  residues, is offered as a way around the gap problem, but it does have not
*  solve other problems, which are detailed in the comments.
    
*     The five measurements are two angles and three distances:
*          zeta is a dihedral angle measured from
*            carbonyl vector o(i-1) to c(i-1) and 
*	     carbonyl vector c(i) to o(i).
*          tau is a dihedral angle measured from
*            vector ca(i-1) to ca(i) and
*            vector ca(i) to ca(i+1).
*          dison3 is hydrogen bond distance measured
*            from o(i) to n(i+3).
*          dison4 is hydrogen bond distance measured
*            from o(i) to n(i+4).
*          discn3 is (nonhydrogen bond) distance measured
*            from c(i) to n(i+3).
*
*              n = nitrogen
*              o = oxygen
*              c = carbon
*              ca = alpha carbon
*              ires = residue number. Each amide is associated with the 
*  residue for the CO group.
*              isub = subunit number

*     For the alpha helix (H), the co groups point roughly along the helix
*  axis, and o(i) is hydrogen bonded to n(i+4) for all but the last three
*  residues.  Here we use the definitions: (1) angle zeta must be between
*  -10 and +45 degrees; (2) dison4(i-1) must be less than 3.5; (3) dison4(i-1)
*  must be less than dison3(i-1) + 0.1, OR dison4(i) must be less than
*  dison3(i) + 0.1 AND dison4(i+1) must be less than dison3(i+1) + 0.1;
*  (4) the helix must extend for at least 4 amides. Note that: (1) the last
*  three nonhydrogen bonded amides are extended automatically; (2) once
*  initiated, if the amides fail the alpha helix critera but meet the 3-10
*  criteria, then the helix is extended as a 3-10 helix.

*     For the 3-10 helix (G), the co groups point roughly along the helix
*  axis, and o(i) is hydrogen bonded to n(i+3) for all but the last two
*  residues.  Here we use the definitions: (1) angle zeta must be between
*  -10 and +45 degrees; (2) dison3(i-1) must be less than 3.5; (3) dison3(i-1)
*  must be less than dison4(i-1) + 0.1, OR dison3(i) must be less than
*  dison4(i) + 0.1; (4) the helix must extend for at least 4 amides. Three
*  amides in a 3-10 helix is a type III beta-turn, and with this definition
*  G will be counted as a turn as defined below.
*  Note that: (1) the last two nonhydrogen bondedamides are extended 
*  automatically; (2) once initiated, if the amides fail the G critera but meet
*  the H  criteria, then the helix is extended as an alpha helix; (3) initiation
*  of G has a lower priority than H.

*     For the extended (E) beta strand, the co groups alternately point
*  almost in the opposite direction, centered around about -157 degrees for the
*  standard twisted beta sheet. The phi-psi plot shows a large
*  deviation, but too large a deviation will not be recognized by circular
*  dichroism as a beta strand.  Our definition is: (1) angle zeta
*  must be less than -140 or greater than 173 degrees; (2) extend for at
*  least 3 amides.  Note that: (1) the final amide in a continuous strand
*  is designated (F) so that it is obvious where breaks occur; (2) no
*  hydrogen bonding is required; (3) initiation of E has a lower priority
*  than H, G or T; (4) the -140 cut off means little overlap with the
*  polyproline II helix defined below.

*     For the beta turn (T), we define the hydrogen bond distance dison3
*  from o(i) to n(i+3) to be less than 3.5 angstroms.  Note that: (1) typeIII
*  beta turns will appear as GGG; (2) initiation of T has a lower priority
*  than H or G, but higher than E which occasionally obscures some turns.

*     For beta turn (N), without a hydrogen bond, we define the distance
*  discn3 from c(i) to n(i+3) to be less than 4.7 angstroms. Note that
*  initiation of N has a lower priority than H, G, E or T.

*     For the 3-1 helix, which is exemplfied by the polyproline II
*   structure (P), we use the criteria of N. Sreerama
*  and R. W. Woody, Biochemistry (1994) 33, 10022-10025: (1) zeta is between
*  -140 and -90 degrees and tau is between 105 and 135 degrees as a seed,
*  then  (2) zeta can be between -150 and -80 degrees and tau between 100
*  and 140 degrees, or (3) both adjacent residues meet the previous criterion
*  #2 and zeta is less than zero and tau between 100 and 140 degrees.  3-1
*  helices with runs of 4 or more have the highest priority, because they
*  can be obscured by beta strand.  However, runs of 2 or 3 have
*   the lowest priority.

*  INPUT:
*     Input is the standard Brookhaven Protein Data Bank file and needs to
*  be the standard name of the form pdbxxxx.ent,
*  which will be requested on the screen.
*     Matrices and some loops are dimensioned for 1000 residues and 10 subunits.
*  The Fortran can be redimensioned by changing the allocations under the
*  "Variables" heading at the top of the program.  If there are more than 10
*  subunits, the program will calculate the secondary structure correctly for
*  the first ten subunits.

*  OUTPUT:
*     There are three output files, the names of which are generated by the
*  program and printed on the screen:
*  (1) Line output (named pdbxxxx.ln) lists the subunit as numbered sequentially by the
*  program, the one letter residue name, the residue number, the calculated
*  secondary structure, and the five corresponding measurements.  If an amide
*  has more than one secondary structure, then the amide will have more than
*  one line in the output.
*  (2) Vector output (named pdbxxxx.vtr) notes the subunit number and gives the
*  corresponding secondary structure(s) over the one letter residue name.
*  (3) Count output (named pdbxxxx.cnt) gives the count of amides in each
*  secondary structure and the fractions of amides in each secondary structure.
*     An amide may belong to more than one secondary structure.  For instance,
*  the last amide in a beta turn may begin a beta strand.  This program will
*  attribute the amide to both structures.  The three letter names for the
*  20 standard residues are converted to their one letter names; other
*  residues are designated as "X".
*     The program counts up the secondary structure and prints it out.
*  Two turns in a row are counted as 5 amide interactions, and you may
*  wish to change this to 4 amide interactions.
*  Since 'N' is a funny structure, you may wish to check vector output
*  and lower its priority relative to other structures.

*  SECONDARY STRUCTURE FOR CIRCULAR DICHROISM:
*     Ends of helices and strands have one nearest neighbor amide-amide
*  interaction, while amides in the center have two.  Since CD at wavelengths
*  shorter than 260nm arises principally from amide-amide interactions
*  these end amides are counted as 1/2 when computing fractions of secondary
*  structure.  All amides are counted completely for T, N, and P.

*--------------------------------------------------------

*    Format Statements
801    format(10x,a60)
802    format(a60)
806    format (a20,a15)
810    format (a11)
830    format(a4,2x,a4,2x,2(a4,2x),a4,1x,2(4x,a4,2x),1x,3(3x,a6))
840    format (21x,i1)
844    format (a4,9x, a3, 1x,a3,1x, a1, a5, 3x, 3f8.3)
845    format (a4,9x, a3, 1x,a3,1x, a1, i4, 4x, 3f8.3)
846    format(a4,7x,a1,1x,i4)
849    format(2x,i1,2x,a5,4x,a1,3x,i4,4x,a1,1x,2(3x,f8.3),3(1x,f8.3))
869    format('Count of amides is ',f6.1)
870    format('Subunit ',i2)
871    format('Count of amide interactions for H is ',f6.1)
872    format('Count of amide interactions for G is ',f6.1)
873    format('Count of amide interactions for E is ',f6.1)
874    format('Count of amide interactions for T is ',f6.1)
875    format('Count of amide interactions for N is ',f6.1)
876    format('Count of amide interactions for P is ',f6.1)
877    format('Totals for secondary structure are:')
878    format('Fractions of secondary structure are:')
879    format('H=',f6.3,',  G=',f6.3,',  E=',f6.3,',  T=',f6.3,
     +',  N=',f6.3,',  P=',f6.3,'  O=',f6.3)
880    format(10x,10(1x,10a1))
881    format(3x,'sec str',10(1x,10a1))
882    format(i2,1x,'residue',10(1x,10a1))
884    format('ERROR:  The number of',1x,a8,1x,'exceeds the',
     +1x,'allocated space (',i4,').  Please change')
885    format('all of the assignments located under',
     +1x,'the "Variables" heading in the Fortran program')
886       format('to an appropriate number for your molecule.')
887    format('H=',f6.1,',  G=',f6.1,',  E=',f6.1,',  T=',f6.1,
     +',  N=',f6.1,',  P=',f6.1,'  Amides=',f7.1)
888    format('Fractions of total secondary structure are:')
    
*    Variables
       integer nres(10),namide(10)
       real c(3,1000,10),o(3,1000,10),ca(3,1000,10),n(3,1000,10)
       real zeta(1000),tau(1000)
       real dison3(1000),dison4(1000),discn3(1000)
       real v1(3),v2(3),v12(3),v23(3),v34(3)
       logical seedi,ppro1i,pproi,pproi1,pproi2,relxdi,relxdi1
       logical irslmt1,irslmt2
       character infile*11,head*4,attp*3,subtp*1,nsubtp*1,olnfile*15
       character*1 ss(1000),ss1(1000),ss2(1000),resname(1000,10)
       character ovtrfile*15,header*60,rsnm*3,cntfile*15
       character*5 resnum(1000,10),xres,nxres
       iresmax=1000
       nsubmax=10
*  number of amino acids per line of vector output
       naavtr=50
       
*    Read pdb file coordinates for desired molecule.	
       print *, 'Enter name of input file as standard pdb designation:'
       read (*,810) infile
       olnfile = infile(1:7)//'.ln'
       ovtrfile = infile(1:7)//'.vtr'
       cntfile = infile(1:7)//'.cnt'    
       print *, 'File name for line output is:'
       write (*,*) olnfile
       print *, 'File name for vector output is:'
       write (*,*) ovtrfile
       print *, 'File name for output of sec struc count for CD is:'
       write (*,*) cntfile
       open (unit=10, file=infile, type='old', form='formatted',
     + blank='zero')
       open (unit=25, file=olnfile, type='replace',form='formatted')
       open (unit=26, file=ovtrfile, type='replace',form='formatted')
       open (unit=27, file=cntfile, type='replace',form='formatted')
          
       write (25,806)'PDB file name:  ',infile
       write (25,810) '    '  
       write (25,806) 'output file name:  ',olnfile           
       write (25,810) '    '

       do i=1,3
*    Read in header

       read (10,801,err=55,end=700)header
       write (25,802) header
       write (26,802) header
       write (27,802) header
       end do
       write (25,810) '    '
       write (25,830)'isub','xres',' res','ires','sstr',
     +'zeta',' tau','dison3','dison4','discn3'

*    Initialize
750    do 50 k=1,nsubmax
       do 50 j=1,iresmax
          resname(j,k)=' '
       do 50 i=1,3
          ca(i,j,k)=9000.0
          c(i,j,k)=9100.0
          o(i,j,k)=9200.0
          n(i,j,k)=9300.0
50     continue
       indexc=0
       nsubtp='z'
       isub=0

*    Read in number of residues (amides + 1)
42     read (10,846,err=55,end=700)head,subtp
         if (head.eq.'SEQR') then
              if (subtp.ne.nsubtp) then
                nsubtp=subtp
                isub=isub+1
              endif
           backspace 10
           read (10,846,err=55,end=700)head,subtp,numres
           namide(isub)=numres-1
         elseif (head.eq.'ATOM') then
           backspace 10
           read (10,844,err=55,end=700)head,attp,rsnm,subtp,xres
           nxres=xres
           backspace 10
           read (10,845,err=55,end=700)head,attp,rsnm,subtp,ires
           iresmin=ires
           nsubtp=subtp
           nsub=1
           backspace 10
           goto 60
         end if
55     goto 42

57     read (10,845,err=110,end=110)head,attp,rsnm,subtp,ires
       if (head.eq.'ATOM') then
         iresmin=ires
         backspace 10
         read (10,844,err=110,end=110)head,attp,rsnm,subtp,xres
         nxres=xres
         backspace 10
         goto 60
       end if
       goto 57

*    Read in coordinates

60     read (10,844,err=100,end=110)head,attp,rsnm,subtp,xres,x,y,z
       Backspace 10
       read (10,845,err=100,end=110)head,attp,rsnm,subtp,ires,x,y,z
       ires=ires-iresmin+1
         if (head.eq.'TER ')then
            goto 57
         endif

         if ((head.eq.'END ').or.(head.eq.'ENDM')) then
           go to 110
         else if (head.eq.'MODE') then
           go to 110
         end if

             if (ires.ge.iresmax) then 
               print 884,'residues',iresmax
               print 885
               print 886
               write (25,802)
               write (25,884),'residues',iresmax
               write (25,885)
               write (25,886)
               goto 110
             end if
*           print *,head,attp,rsnm,subtp,ires,x,y,z

           if (subtp.eq.nsubtp) then
             isub=nsub
           else 
             if (nsub.ge.nsubmax) then 
               print 884,'subunits',nsubmax
               print 885
               print 886
               write (25,802)
               write (25,884),'subunits',nsubmax
               write (25,885)
               write (25,886)
               goto 110
             end if
              nsub=nsub+1
              isub=nsub
              nsubtp=subtp
           end if

           if (resname(ires,isub).eq.' ')then
                     if(rsnm.eq.'PHE')then
                               resname(ires,isub)='F'
                     else if(rsnm.eq.'TYR')then
                               resname(ires,isub)='Y'
                     else if(rsnm.eq.'TRP')then
                               resname(ires,isub)='W'
                     else if(rsnm.eq.'LYS')then
                               resname(ires,isub)='K'
                     else if(rsnm.eq.'ARG')then
                               resname(ires,isub)='R'
                     else if(rsnm.eq.'ASP')then
                               resname(ires,isub)='D'
                     else if(rsnm.eq.'GLU')then
                               resname(ires,isub)='E'
                     else if(rsnm.eq.'ASN')then
                               resname(ires,isub)='N'
                     else if(rsnm.eq.'GLN')then
                               resname(ires,isub)='Q'  
                     else if(rsnm.eq.'ALA')then
                               resname(ires,isub)='A'
                     else if(rsnm.eq.'GLY')then
                               resname(ires,isub)='G'
                     else if(rsnm.eq.'VAL')then
                               resname(ires,isub)='V'
                     else if(rsnm.eq.'THR')then
                               resname(ires,isub)='T'
                     else if(rsnm.eq.'HIS')then
                               resname(ires,isub)='H'
                     else if(rsnm.eq.'PRO')then
                               resname(ires,isub)='P'
                     else if(rsnm.eq.'LEU')then
                               resname(ires,isub)='L'
                     else if(rsnm.eq.'SER')then
                               resname(ires,isub)='S'
                     else if(rsnm.eq.'MET')then
                               resname(ires,isub)='M'
                     else if(rsnm.eq.'ILE')then
                               resname(ires,isub)='I'
                     else if(rsnm.eq.'CYS')then
                               resname(ires,isub)='C'
                     else if(rsnm.eq.'HOH')then
                               goto 110
                     else 
                               resname(ires,isub)='X'
                     end if
              endif

              if (attp.eq.'CA ') then
                ca(1,ires,isub)=x
	        ca(2,ires,isub)=y
	        ca(3,ires,isub)=z
*                print *,attp,rsnm,subtp,isub,ires,ca(1,ires,isub)
              end if

              if (attp.eq.'C  ') then
                c(1,ires,isub)=x
	        c(2,ires,isub)=y
	        c(3,ires,isub)=z
                    indexc=1
*                print *,attp,rsnm,subtp,isub,ires,c(1,ires,isub)
              end if
	      
              if (attp.eq.'O  ') then
                o(1,ires,isub)=x
	        o(2,ires,isub)=y
	        o(3,ires,isub)=z
*                print *,attp,rsnm,subtp,isub,ires,o(1,ires,isub)
              end if
 
              if (attp.eq.'N  ') then
                n(1,ires,isub)=x
	        n(2,ires,isub)=y
	        n(3,ires,isub)=z
*                print *,attp,rsnm,subtp,isub,ires,n(1,ires,isub)
              end if

              nres(isub)=ires
              resnum(ires,isub)=xres
              nxres=xres


100      go to 60
110      continue

         if(indexc.eq.0) then
         write(*,*) 'Your data are incomplete:'
         write(*,*) 'it may contain only alpha carbons'
         write(25,*)
         write(25,*) '*********************************'
         write(25,*) 'Your data are incomplete:'
         write(25,*) 'it may contain only alpha carbons'
         write(25,*) '*********************************'
         write(25,*)
         write(26,*)
         write(26,*) '*********************************'
         write(26,*) 'Your data are incomplete:'
         write(26,*) 'it may contain only alpha carbons'
         write(26,*) '*********************************'
         write(26,*)
         end if

              totamid=0.0
              totcnth=0.0
              totcntg=0.0
              totcnte=0.0
              totcntt=0.0
              totcntu=0.0
              totcntp=0.0


           do 650 isub=1,nsub
              nnres=nres(isub)
              totamid=totamid+(1.0*nnres)-1.0

       do ires=1,iresmax
          zeta(ires)=360.0
          tau(ires)=360.0
          dison3(ires)=1000.0
          dison4(ires)=1000.0
          discn3(ires)=1000.0
       end do
       do ires=1,iresmax
          ss(ires)=' '
          ss1(ires)=' '
          ss2(ires)=' '
       end do

          do ires=1,nnres-3
* Calculates the distance between two atoms (here for a co-nh hydrogen bond)
      if ((resname(ires,isub).eq.' ').or.
     +(resname(ires+3,isub).eq.' ')) then
                  v=1000.0
                  goto 120
               end if
              call dis(o(1,ires,isub),n(1,ires+3,isub),v)
120              dison3(ires)=v
          end do

          do ires=1,nnres-4
* Calculates the distance between two atoms (here for a co-nh hydrogen bond)
      if ((resname(ires,isub).eq.' ').or.
     +(resname(ires+4,isub).eq.' ')) then
                  v=1000.0
                  goto 121
               end if
              call dis(o(1,ires,isub),n(1,ires+4,isub),v)          
121              dison4(ires)=v
          end do

          do ires=1,nnres-3
* Calculates the distance between two atoms (here for cn in a beta turn)
      if ((resname(ires,isub).eq.' ').or.
     +(resname(ires+3,isub).eq.' ')) then
                  v=1000.0
                  goto 122
               end if
              call dis(c(1,ires,isub),n(1,ires+3,isub),v)          
122              discn3(ires)=v
          end do

*                 print *,'CA',subtp,isub,ires,ca(1,ires,isub),
*     +ca(2,ires,isub),ca(3,ires,isub)
*                 print *,'C ',subtp,isub,ires,c(1,ires,isub),
*     +c(2,ires,isub),c(3,ires,isub)
*                 print *,'O ',subtp,isub,ires,o(1,ires,isub),
*     +o(2,ires,isub),o(3,ires,isub)
*                 print *,'N ',subtp,isub,ires,n(1,ires,isub),
*     +n(2,ires,isub),n(3,ires,isub)

*   Calculates angle zeta between COs for ires-1 and ires.


          do ires=2,nnres
      if ((resname(ires,isub).eq.' ').or.
     +(resname(ires-1,isub).eq.' ')) then
                  thetan=360.00
                  goto 123
             end if
*   Calculates the difference vector between two points
             call diff(o(1,ires-1,isub),c(1,ires-1,isub),v12)
             call diff(c(1,ires-1,isub),c(1,ires,isub),v23)
             call diff(c(1,ires,isub),o(1,ires,isub),v34)

*   Calculates the cross product to find the normal vectors.
             call cross(v12,v23,v1)
             call cross(v23,v34,v2)

*   Calculates the angle between the two normals using the dot product and
*   the cross product (for the sign determination).        
             call calcdiang(v1,v2,v23,thetan)
123             zeta(ires)=thetan
          end do

*   Calculates angle tau between CAs for res-1 to res, and for res to res+1

          do ires=2,nnres-1
             if ((resname(ires-1,isub).eq.' ').or.(resname(ires,isub)
     +.eq.' ').or.(resname(ires+1,isub).eq.' ')) then
                  thetan=360.00
                  goto 124
             end if
*   Calculates the difference vector between two points
             call diff(ca(1,ires-1,isub),ca(1,ires,isub),v12)
             call diff(ca(1,ires,isub),ca(1,ires+1,isub),v23)

*   Calculates the angle between the two vectors.
	     call calcangle(v12,v23,thetan)
124             tau(ires)=thetan
          end do

200       continue

*   Assigns geometric results to secondary structures

            ires=1
            iflag=0
            iflagt=0
            cnth=0.0
            cntg=0.0
            cnte=0.0
            cntt=0.0
            cntu=0.0
            cntp=0.0
            icntp=0


500   continue


      if(ires.ge.nnres) goto 625
            indxe=1
            indxg=2
            indxh=3

*  Since the program also increments ires below, it does not always go thru this
*  if statement, but initialization ensures that missing residues will not be
*  incorporated in secondary structure and missing residues will arrive here.
505   if(resname(ires,isub).eq.' ')then
            resname(ires,isub)='-'
            ss(ires)='*'
            ires=ires+1
            goto 600
      end if
      ires=ires+1
            indexh=0
            indexg=0
            indexe=0
            indext=0
            indexu=0

*   alpha helix called (H)--------------------
*       with the final residue in the helix called 'h'

* If statement requires 4 amides in the helix
510     if ((zeta(ires).gt.-10.).and.(zeta(ires).lt.45.)   
     +.and.(zeta(ires+1).gt.-10.).and.(zeta(ires+1).lt.45.)
     +.and.(zeta(ires+2).gt.-10.).and.(zeta(ires+2).lt.45.)
     +.and.((dison4(ires-1).lt.dison3(ires-1)+0.1)
     +.or.((dison4(ires).lt.dison3(ires)+0.1)
     +.and.(dison4(ires+1).lt.dison3(ires+1)+0.1)))
     +.and.(dison4(ires-1).le.3.5).and.(ires.le.(nnres-2))) then
                     indexh=1
*                    type 849,isub,resname(ires-1,isub),ires-1,'H',
*     +zeta(ires-1),tau(ires-1),dison3(ires-1),
*     +dison4(ires-1),discn3(ires-1)
                    write (25,849)isub,resnum(ires-1,isub),
     +resname(ires-1,isub),ires-1,'H',zeta(ires-1),tau(ires-1),
     +dison3(ires-1),dison4(ires-1),discn3(ires-1)
               if (ss1(ires-1).ne.' ') then
                    ss2(ires-1)='H'
               else if(ss(ires-1).ne.' ') then
                    ss1(ires-1)='H'
               else
                    ss(ires-1)='H'
               endif
                    ires=ires+1
                    goto 510

         else if ((zeta(ires).gt.-10.).and.(zeta(ires).lt.45.)
     +.and.(zeta(ires+1).gt.-10.).and.(zeta(ires+1).lt.45.)
     +.and.(zeta(ires+2).gt.-10.).and.(zeta(ires+2).lt.45.)
     +.and.((dison3(ires-1).lt.dison4(ires-1)+0.1)
     +.or.((dison3(ires).lt.dison4(ires)+0.1)
     +.and.(dison3(ires+1).lt.dison4(ires+1)+0.1)))
     +.and.(dison3(ires-1).le.3.5).and.(ires.le.(nnres-2))) then
                       indexh=0
                       goto 511

         else if (indexh.ne.0) then
           do i=ires-1,ires
*                    type 849,isub,resname(i,isub),i,'H',
*     +zeta(i),tau(i),dison3(i),dison4(i),discn3(i)
                    write (25,849)isub,resnum(i,isub),resname(i,isub),
     +i,'H',zeta(i),tau(i),dison3(i),dison4(i),discn3(i)
               if(ss(i).ne.' ') then
                    ss1(i)='H'
               else
                    ss(i)='H'
               endif
           end do
*                    type 849,isub,resname(ires+1,isub),
*     +ires+1,'h',zeta(ires+1),tau(ires+1),dison3(ires+1),
*     +dison4(ires+1),discn3(ires+1)
                    write (25,849)isub,resnum(i,isub),
     +resname(ires+1,isub),ires+1,'h',zeta(ires+1),tau(ires+1),
     +dison3(ires+1),dison4(ires+1),discn3(ires+1)
               if(ss(ires+1).ne.' ') then
                    ss1(ires+1)='h'
               else
                    ss(ires+1)='h'
               endif
                       indexh=0
                       ires=ires+1
                    goto 500
        end if

*   3-10 helix called (G)--------------------
*       with the final residue in the helix called 'g'

* If statement requires 4 amides in the helix; 3 amides will be a turn.
511     if ((zeta(ires).gt.-10.).and.(zeta(ires).lt.45.)
     +.and.(zeta(ires+1).gt.-10.).and.(zeta(ires+1).lt.45.)
     +.and.(zeta(ires+2).gt.-10.).and.(zeta(ires+2).lt.45.)
     +.and.((dison3(ires-1).lt.dison4(ires-1)+0.1)
     +.or.((dison3(ires).lt.dison4(ires)+0.1)
     +.and.(dison3(ires+1).lt.dison4(ires+1)+0.1)))
     +.and.(dison3(ires-1).le.3.5).and.(ires.le.(nnres-2))) then
                       indexg=1
*                    type 849,isub,resname(ires-1,isub),ires-1,'G',
*     +zeta(ires-1),tau(ires-1),dison3(ires-1),
*     +dison4(ires-1),discn3(ires-1)
                    write (25,849)isub,resnum(ires-1,isub),
     +resname(ires-1,isub),ires-1,'G',zeta(ires-1),tau(ires-1),
     +dison3(ires-1),dison4(ires-1),discn3(ires-1)
               if(ss1(ires-1).ne.' ') then
                    ss2(ires-1)='G'
               else if(ss(ires-1).ne.' ') then
                    ss1(ires-1)='G'
               else
                    ss(ires-1)='G'
               endif
                    ires=ires+1
                    goto 511

         else if ((zeta(ires).gt.-10.).and.(zeta(ires).lt.45.)   
     +.and.(zeta(ires+1).gt.-10.).and.(zeta(ires+1).lt.45.)
     +.and.(zeta(ires+2).gt.-10.).and.(zeta(ires+2).lt.45.)
     +.and.((dison4(ires-1).lt.dison3(ires-1)+0.1)
     +.or.((dison4(ires).lt.dison3(ires)+0.1)
     +.and.(dison4(ires+1).lt.dison3(ires+1)+0.1)))
     +.and.(dison4(ires-1).le.3.5).and.(ires.le.(nnres-2))) then
                       indexg=0
                       goto 510

         else if (indexg.ne.0) then
           do i=ires-1,ires
*                    type 849,isub,resname(i,isub),i,'G',
*     +zeta(i),tau(i),dison3(i),dison4(i),discn3(i)
                    write (25,849)isub,resnum(i,isub),
     +resname(i,isub),i,'G',
     +zeta(i),tau(i),dison3(i),dison4(i),discn3(i)
               if(ss(i).ne.' ') then
                    ss1(i)='G'
               else
                    ss(i)='G'
               endif
            end do
*                    type 849,isub,resname(ires+1,isub),
*     +ires+1,'g',zeta(ires+1),tau(ires+1),dison3(ires+1),
*     +dison4(ires+1),discn3(ires+1)
                    write (25,849)isub,resnum(ires+1,isub),
     +resname(ires+1,isub),ires+1,'g',zeta(ires+1),tau(ires+1),
     +dison3(ires+1),dison4(ires+1),discn3(ires+1)
               if(ss(ires+1).ne.' ') then
                    ss1(ires+1)='g'
               else
                    ss(ires+1)='g'
               endif
                       indexg=0
                       ires=ires+1
                    goto 500
        end if

      if(ires.gt.nnres-3) goto 499

*   poly(L-proline)II type (3-1) helix (four in a row is a minimum)
*   called (P)--------------
*   with the final residue in the helix called (p)

*   Set up logical variables

415     seedi=((zeta(ires).gt.-140.).and.(zeta(ires).lt.-90.)
     +.and.(tau(ires).gt.105.).and.(tau(ires).lt.135.))

*   First set up seed

       if(seedi) then
          icntp=1
          goto 450
       else
          goto 499
       endif

*   Then extend 3-1 helix

450    if (ires.ge.nnres) goto 489
           ires=ires+1

        seedi=((zeta(ires).gt.-140.).and.(zeta(ires).lt.-90.)
     +.and.(tau(ires).gt.105.).and.(tau(ires).lt.135.))
        ppro1i=
     +((zeta(ires-1).gt.-150.).and.(zeta(ires-1).lt.-80.)
     +.and.(tau(ires-1).gt.100.).and.(tau(ires-1).lt.140.))
        pproi=((zeta(ires).gt.-150.).and.(zeta(ires).lt.-80.)
     +.and.(tau(ires).gt.100.).and.(tau(ires).lt.140.))
        pproi1=
     +((zeta(ires+1).gt.-150.).and.(zeta(ires+1).lt.-80.)
     +.and.(tau(ires+1).gt.100.).and.(tau(ires+1).lt.140.))
        pproi2=
     +((zeta(ires+2).gt.-150.).and.(zeta(ires+2).lt.-80.)
     +.and.(tau(ires+2).gt.100.).and.(tau(ires+2).lt.140.))
        relxdi=((zeta(ires).lt.0.)
     +.and.(tau(ires).gt.100.).and.(tau(ires).lt.140.))     
        relxdi1=((zeta(ires+1).lt.0.)
     +.and.(tau(ires+1).gt.100.).and.(tau(ires+1).lt.140.))
        irslmt1=(ires.le.nnres-1)
        irslmt2=(ires.le.nnres-2)

               if(pproi.or.(irslmt1.and.ppro1i.
     +and.relxdi.and.pproi1)) then
                     icntp=icntp+1
                     goto 450
               endif

489            if(icntp.ge.4) then
                  if (ss(ires-icntp-1).eq.' ')then
*     type 849,isub,resname(ires-icntp-1,isub),ires-icntp-1,'-',
*     +zeta(ires-icntp-1),tau(ires-icntp-1),
*     +dison3(ires-icntp-1),dison4(ires-icntp-1),discn3(ires-icntp-1)
                     write (25,849)isub,resnum(ires-icntp-1,isub),
     +resname(ires-icntp-1,isub),ires-icntp-1,'-',zeta(ires-icntp-1),
     +tau(ires-icntp-1),dison3(ires-icntp-1),dison4(ires-icntp-1),
     +discn3(ires-icntp-1)

                     ss(ires-icntp-1)='-'
                  endif
                      do i=icntp,1,-1
                        irs=ires-i
*                    type 849,isub,resname(irs,isub),irs,'P',
*     +zeta(irs),tau(irs),dison3(irs),dison4(irs),discn3(irs)
                    write (25,849)isub,resnum(irs,isub),
     +resname(irs,isub),irs,'P',zeta(irs),tau(irs),
     +dison3(irs),dison4(irs),discn3(irs)
                    ss(irs)='P'
                      enddo

                        irs=ires-1
*                    type 849,isub,resname(irs,isub),irs,'p',
*     +zeta(irs),tau(irs),dison3(irs),dison4(irs),discn3(irs)
                    write (25,849)isub,resnum(irs,isub),
     +resname(irs,isub),irs,'p',zeta(irs),tau(irs),
     +dison3(irs),dison4(irs),discn3(irs)
                    ss(irs)='p'

                   ires=ires-1
                   goto 500
                else
                ires=ires-icntp
                endif

*   beta turn with hydrogen bond called (T)--------------------

499    if (ires.ge.nnres-2) goto 515

513    if(dison3(ires-1).le.3.5) then
*                    type 849,isub,resname(ires-1,isub),ires-1,'T',
*     +zeta(ires-1),tau(ires-1),dison3(ires-1),
*     +dison4(ires-1),discn3(ires-1)
                    write (25,849)isub,resnum(ires-1,isub),
     +resname(ires-1,isub),ires-1,'T',zeta(ires-1),tau(ires-1),
     +dison3(ires-1),dison4(ires-1),discn3(ires-1)
               if(ss1(ires-1).ne.' ') then
                    ss2(ires-1)='T'
               else if(ss(ires-1).ne.' ') then
                    ss1(ires-1)='T'
               else
                    ss(ires-1)='T'
               endif

            do i=ires,ires+1
*                    type 849,isub,resname(i,isub),i,'T',
*    +zeta(i),tau(i),dison3(i),dison4(i),discn3(i)
                    write (25,849)isub,resnum(i,isub),resname(i,isub),
     +i,'T',zeta(i),tau(i),dison3(i),dison4(i),discn3(i)
               if(ss(i).ne.' ') then
                    ss1(i)='T'
               else
                    ss(i)='T'
               endif
            end do

                    goto 500
       end if

*   extended beta strand called "E"--------------------
*       with the final residue in the beta strand called 'e'

512      if (((zeta(ires).gt.173.).and.(zeta(ires).lt.181.)
     +.or.(zeta(ires).le.-140.)).and.
     +((zeta(ires+1).ge.173.).and.(zeta(ires+1).lt.181.)
     +.or.(zeta(ires+1).le.-140.))
     +.and.(ires.lt.nnres)) then
                    indexe=1
*                    type 849,isub,resname(ires-1,isub),ires-1,'E',
*     +zeta(ires-1),tau(ires-1),dison3(ires-1),
*     +dison4(ires-1),discn3(ires-1)
                    write (25,849)isub,resnum(ires-1,isub),
     +resname(ires-1,isub),ires-1,'E',zeta(ires-1),tau(ires-1),
     +dison3(ires-1),dison4(ires-1),discn3(ires-1)
               if(ss1(ires-1).ne.' ') then
                    ss2(ires-1)='E'
               else if(ss(ires-1).ne.' ') then
                    ss1(ires-1)='E'
               else
                    ss(ires-1)='E'
               endif
                    ires=ires+1
                    goto 512

         else if (indexe.ne.0) then
*                    type 849,isub,resname(ires-1,isub),ires-1,'E',
*     +zeta(ires-1),tau(ires-1),
*     +dison3(ires-1),dison4(ires-1),discn3(ires-1)
                    write (25,849)isub,resnum(ires-1,isub),
     +resname(ires-1,isub),ires-1,'E',zeta(ires-1),tau(ires-1),
     +dison3(ires-1),dison4(ires-1),discn3(ires-1)
               if(ss(ires-1).ne.' ') then
                    ss1(ires-1)='E'
               else
                    ss(ires-1)='E'
               endif
*                    type 849,isub,resname(ires,isub),ires,'e',
*     +zeta(ires),tau(ires),
*     +dison3(ires),dison4(ires),discn3(ires)
                    write (25,849)isub,resnum(ires,isub),
     +resname(ires,isub),ires,'e',zeta(ires),tau(ires),
     +dison3(ires),dison4(ires),discn3(ires)
                    ss(ires)='e'
                       indexe=0
                    goto 500
       end if

*   beta turn without hydrogen bond called (N)--------------------

514    if((discn3(ires-1).le.4.7).and.(dison3(ires-2).gt.3.5)) then
*                    type 849,isub,resname(ires-1,isub),ires-1,'N',
*     +zeta(ires-1),tau(ires-1),dison3(ires-1),
*     +dison4(ires-1),discn3(ires-1)
                    write (25,849)isub,resnum(ires-1,isub),
     +resname(ires-1,isub),ires-1,'N',zeta(ires-1),tau(ires-1),
     +dison3(ires-1),dison4(ires-1),discn3(ires-1)

               if(ss1(ires-1).ne.' ') then
                    ss2(ires-1)='N'
               else if(ss(ires-1).ne.' ') then
                    ss1(ires-1)='N'
               else
                    ss(ires-1)='N'
               endif

            do i=ires,ires+1

*                    type 849,isub,resname(i,isub),i,'N',
*     +zeta(i),tau(i),dison3(i),dison4(i),discn3(i)
                    write (25,849)isub,resnum(i,isub),resname(i,isub),
     +i,'N',zeta(i),tau(i),dison3(i),dison4(i),discn3(i)
               if(ss(i).ne.' ') then
                    ss1(i)='N'
               else
                    ss(i)='N'
               endif
            end do

                    goto 500
       end if


*   poly(L-proline)II type (3-1) helix (two in a row is a minimum)
*   called (P)--------------
*   with the final residue in the helix called (p)

*   Set up logical variables

515     seedi=((zeta(ires).gt.-140.).and.(zeta(ires).lt.-90.)
     +.and.(tau(ires).gt.105.).and.(tau(ires).lt.135.))

*   First set up seed

       if(seedi) then
          icntp=1
          goto 550
       else
          goto 600
       endif

*   Then extend 3-1 helix

550    if (ires.ge.nnres) goto 589
           ires=ires+1

        seedi=((zeta(ires).gt.-140.).and.(zeta(ires).lt.-90.)
     +.and.(tau(ires).gt.105.).and.(tau(ires).lt.135.))
        ppro1i=
     +((zeta(ires-1).gt.-150.).and.(zeta(ires-1).lt.-80.)
     +.and.(tau(ires-1).gt.100.).and.(tau(ires-1).lt.140.))
        pproi=((zeta(ires).gt.-150.).and.(zeta(ires).lt.-80.)
     +.and.(tau(ires).gt.100.).and.(tau(ires).lt.140.))
        pproi1=
     +((zeta(ires+1).gt.-150.).and.(zeta(ires+1).lt.-80.)
     +.and.(tau(ires+1).gt.100.).and.(tau(ires+1).lt.140.))
        pproi2=
     +((zeta(ires+2).gt.-150.).and.(zeta(ires+2).lt.-80.)
     +.and.(tau(ires+2).gt.100.).and.(tau(ires+2).lt.140.))
        relxdi=((zeta(ires).lt.0.)
     +.and.(tau(ires).gt.100.).and.(tau(ires).lt.140.))     
        relxdi1=((zeta(ires+1).lt.0.)
     +.and.(tau(ires+1).gt.100.).and.(tau(ires+1).lt.140.))
        irslmt1=(ires.le.nnres-1)
        irslmt2=(ires.le.nnres-2)

               if(pproi.or.(irslmt1.and.ppro1i.
     +and.relxdi.and.pproi1)) then
                     icntp=icntp+1
                     goto 550
               endif

589            if(icntp.ge.2) then
                  if (ss(ires-icntp-1).eq.' ')then
*     type 849,isub,resname(ires-icntp-1,isub),ires-icntp-1,'-',
*     +zeta(ires-icntp-1),tau(ires-icntp-1),
*     +dison3(ires-icntp-1),dison4(ires-icntp-1),discn3(ires-icntp-1)
                     write (25,849)isub,resnum(ires-icntp-1,isub),
     +resname(ires-icntp-1,isub),ires-icntp-1,'-',zeta(ires-icntp-1),
     +tau(ires-icntp-1),dison3(ires-icntp-1),dison4(ires-icntp-1),
     +discn3(ires-icntp-1)

                     ss(ires-icntp-1)='-'
                  endif
                      do i=icntp,2,-1
                        irs=ires-i
*                    type 849,isub,resname(irs,isub),irs,'P',
*     +zeta(irs),tau(irs),dison3(irs),dison4(irs),discn3(irs)
                    write (25,849)isub,resnum(irs,isub),
     +resname(irs,isub),irs,'P',zeta(irs),tau(irs),
     +dison3(irs),dison4(irs),discn3(irs)
                    ss(irs)='P'
                      enddo

                        irs=ires-1
*                    type 849,isub,resname(irs,isub),irs,'p',
*     +zeta(irs),tau(irs),dison3(irs),dison4(irs),discn3(irs)
                    write (25,849)isub,resnum(irs,isub),
     +resname(irs,isub),irs,'p',zeta(irs),tau(irs),
     +dison3(irs),dison4(irs),discn3(irs)
                    ss(irs)='p'

                   ires=ires-1
                   goto 500
                else
                ires=ires-icntp
                endif

600   continue
*                    type 849,isub,resname(ires-1,isub),ires-1,'-',
*     +zeta(ires-1),tau(ires-1),
*     +dison3(ires-1),dison4(ires-1),discn3(ires-1)
                    write (25,849)isub,resnum(ires-1,isub),
     +resname(ires-1,isub),ires-1,'-',zeta(ires-1),tau(ires-1),
     +dison3(ires-1),dison4(ires-1),discn3(ires-1)

               if(ss1(ires-1).ne.' ') then
                    ss2(ires-1)=' '
               else if(ss(ires-1).ne.' ') then
                    ss1(ires-1)=' '
               else
                    ss(ires-1)='-'
               endif

*       if(ires.eq.nnres) then
*                    type 849,isub,resname(ires,isub),ires,'-',
*     +zeta(ires),tau(ires),dison3(ires),dison4(ires),discn3(ires)
*                    write (25,849)isub,resnum(ires,isub),
*      +resname(ires,isub),ires,'-',
*     +zeta(ires),tau(ires),dison3(ires),dison4(ires),discn3(ires)
*                         ss(ires)='-'
*       end if
                         goto 500

*  Prints out the secondary structure in vector format
625              realnn=real(nnres)/(1.0*naavtr)
                   nn=realnn
                   if(realnn-real(nn).gt.0.) nn=nn+1

       do i=1,nn
         i1=((i-1)*naavtr)+1
         n1=(i*naavtr)
         write(26,880),(ss2(ires),ires=i1,n1)
         write(26,880),(ss1(ires),ires=i1,n1)
         write(26,881),(ss(ires),ires=i1,n1)
         write(26,882),isub,(resname(ires,isub),ires=i1,n1)
       end do

*   Counts up the secondary structure and prints out
*   Since 'N' is a funny structure, you may wish to check vector output
*   and lower its priority relative to other structures
                  cntp=0.0
                  cnth=0.0
                  cntg=0.0
                  cntt=0.0
                  cnte=0.0
                  cntu=0.0
       do ires=1,nnres
                     iss1=0
            if(ss1(ires).ne.' ') then
                     iss1=1
                if(ss1(ires).eq.'P') then
                   cntp=cntp+0.5
                   iflagp=1
                elseif(ss1(ires).eq.'H') then
                   cnth=cnth+0.5
                   iflaghg=1
                elseif(ss1(ires).eq.'G') then
                   cntg=cntg+0.5
                   iflaghg=1
                elseif(ss1(ires).eq.'T') then
                   cntt=cntt+0.5
                   iflagt=1
                elseif(ss1(ires).eq.'E') then
                   cnte=cnte+0.5
		   iflage=1
                elseif(ss1(ires).eq.'N') then
                   cntu=cntu+0.5
                   iflagu=1
                endif
            endif
                if(ss(ires).eq.'P') then
                   if(iflagp.ne.1) then
                   cntp=cntp+0.5
		   iflagp=1
                   elseif(iss1.eq.1) then
                   cntp=cntp+0.5
                   else
                   cntp=cntp+1.0
                   endif
                elseif(ss(ires).eq.'p') then
                   cntp=cntp+0.5
                      if((iss1.eq.1).and.(ss(ires+1).eq.'P')) then
                      iflagp=1
                      else
                      iflagp=0
                      endif
                elseif(ss(ires).eq.'H') then
                   if((iflaghg.eq.1).and.(iss1.eq.0).and.
     +((ss(ires+1).eq.'H').or.(ss(ires+1).eq.'h').or.
     +(ss(ires+1).eq.'G').or.(ss(ires+1).eq.'g'))) then
                   cnth=cnth+1.0
                   elseif
     +((ss(ires+1).eq.'H').or.(ss(ires+1).eq.'G')) then
                   cnth=cnth+0.5
                   iflaghg=1
                   endif
                elseif(ss(ires).eq.'h') then
                   cnth=cnth+0.5
                      if((iss1.eq.1).and.
     +((ss(ires+1).eq.'H').or.(ss(ires+1).eq.'G'))) then
                      iflaghg=1
                      else
                      iflaghg=0
                      endif
                elseif(ss(ires).eq.'G') then
                   if((iflaghg.eq.1).and.(iss1.eq.0).and.
     +((ss(ires+1).eq.'H').or.(ss(ires+1).eq.'h').or.
     +(ss(ires+1).eq.'G').or.(ss(ires+1).eq.'g'))) then
                   cntg=cntg+1.0
                   elseif
     +((ss(ires+1).eq.'H').or.(ss(ires+1).eq.'G')) then
                   cntg=cntg+0.5
                   iflaghg=1
                   endif
                elseif(ss(ires).eq.'g') then
                   cntg=cntg+0.5
                      if((iss1.eq.1).and.
     +((ss(ires+1).eq.'H').or.(ss(ires+1).eq.'G'))) then
                      iflaghg=1
                      else
                      iflaghg=0
                      endif
                elseif(ss(ires).eq.'T') then
                   if(iflagt.ne.1) then
                   cntt=cntt+0.5
                   iflagt=1
                   elseif((ss(ires+1).eq.'T').and.(iss1.eq.0)) then
                   cntt=cntt+1.0
                   iflagt=1
                   elseif((ss(ires+1).eq.'T').and.(iss1.eq.1)) then
                   cntt=cntt+0.5
                   else
                   cntt=cntt+0.5
                   iflagt=0
                   endif
                elseif(ss(ires).eq.'E') then
                   if(iflage.ne.1) then
                   cnte=cnte+0.5
		   iflage=1
                   elseif(iss1.eq.1) then
                   cnte=cnte+0.5
                   else
                   cnte=cnte+1.0
                   endif
                elseif(ss(ires).eq.'e') then
                   cnte=cnte+0.5
                      if((iss1.eq.1).and.(ss(ires+1).eq.'E')) then
                      iflage=1
                      else
                      iflage=0
                      endif
                elseif(ss(ires).eq.'N') then
                   if(iflagu.ne.1) then
                   cntu=cntu+0.5
                   iflagu=1
                   elseif((ss(ires+1).eq.'N').and.(iss1.eq.0)) then
                   cntu=cntu+1.0
                   iflagu=1
                   elseif((ss(ires+1).eq.'N').and.(iss1.eq.1)) then
                   cntu=cntu+0.5
                   iflagu=1
                   else
                   cntu=cntu+0.5
                   iflagu=0
                   endif
                endif
        enddo

           amid=1.0*namide(isub)
      write(27,810) '   '
      write(27,870), isub
      write(27,871), cnth
      write(27,872), cntg
      write(27,873), cnte
      write(27,874), cntt
      write(27,875), cntu
      write(27,876), cntp
      write(27,869), amid

           frach=cnth/amid
           fracg=cntg/amid
           frace=cnte/amid
           fract=cntt/amid
           fracu=cntu/amid
           fracp=cntp/amid
           fraco=1.0-frach-fracg-frace-fract-fracu-fracp
      write(27,810) '   '
      write(27,878)
      write(27,879),frach,fracg,frace,fract,fracu,fracp,fraco

              totcnth=totcnth+cnth
              totcntg=totcntg+cntg
              totcnte=totcnte+cnte
              totcntt=totcntt+cntt
              totcntu=totcntu+cntu
              totcntp=totcntp+cntp

650      continue

      write(27,810) '   '
      write(27,810) '   '
      write(27,877)
      Write(27,887),totcnth,totcntg,totcnte,totcntt,totcntu,
     +totcntp,totamid
           frach=totcnth/totamid
           fracg=totcntg/totamid
           frace=totcnte/totamid
           fract=totcntt/totamid
           fracu=totcntu/totamid
           fracp=totcntp/totamid
           fraco=1.0-frach-fracg-frace-fract-fracu-fracp
      write(27,810) '   '
      write(27,888)
      write(27,879),frach,fracg,frace,fract,fracu,fracp,fraco

      goto 750
700      end

*------------------------------------------------------------------------------
	subroutine dis(p1,p2,v)

*   Variables 
        real p1(3),p2(3)

*   Calculates a different vector between two points.
 
 	v=(sqrt((p2(1)-p1(1))**2+(p2(2)-
     +     p1(2))**2+(p2(3)-p1(3))**2))
        	
	return
	end

*-------------------------------------------------------------------------------
	Subroutine calcdiang(p1,p2,v23,thetaa)

*   Calculates the angle between two vectors by using the dot product.

*   Variables
        real v1,v2,p1(3),p2(3),uv,thetaa
        real dp,v23(3),cv(3),angle

        call cross(p1,p2,cv)
        
        v1=(sqrt(p1(1)**2+p1(2)**2+p1(3)**2))
	
        v2=(sqrt(p2(1)**2+p2(2)**2+p2(3)**2))
       
        call dot(p1,p2,uv)
       
        angle=(uv/(v1*v2))
        
        if ((angle.lt.1.0).or.(angle.gt.-1.0))then
                 thetaa= acos(angle)*180.0/3.1415927
        endif

   	if (angle.ge.1.0) then 
		thetaa= 0.0
	endif

        call dot(cv,v23,dp)

        if (dp.lt.0) then
                thetaa=0-thetaa
		
         endif
       
         return
         end

*------------------------------------------------------------------------------
	Subroutine calcangle(p1,p2,thetaa)

*   Variables
	real v1,v2,p1(3),p2(3),uv,thetaa,angle

	v1=(sqrt(p1(1)**2+p1(2)**2+p1(3)**2))
        v2=(sqrt(p2(1)**2+p2(2)**2+p2(3)**2))
        
      	call dot(p1,p2,uv)
        
        angle=(uv/(v1*v2))

        if ((angle.lt.1.0).or.(angle.gt.-1.0)) then
                thetaa= acos(-angle)*180.0/3.1415927
        endif

   	if(angle.ge.1.0) then 
		thetaa= 0.0
	endif

	return
	end

*-------------------------------------------------------------------------------
        subroutine dot(v1,v2,uv)

*   Calculates the dot product of two vectors.

*   Variables
        real uv,v1(3),v2(3)
      
        uv=(v1(1)*v2(1))+(v1(2)*v2(2))+(v1(3)*v2(3))
	
        return
	end

*-------------------------------------------------------------------------------	
	subroutine cross(u,v,n)

*   Calculates the cross product of two vectors. The output is the normal.

*   Variables
	real u(3),v(3),n(3)

	n(1)=(u(2)*v(3)-(u(3)*v(2)))
	n(2)=(u(3)*v(1)-(u(1)*v(3)))
	n(3)=(u(1)*v(2)-(u(2)*v(1)))

	return
	end

*-------------------------------------------------------------------------------
	subroutine diff(p1,p2,v)

*   Calculates a difference vector between two points.
 
*   Variables  
	real p1(3),p2(3),v(3)
 	
	do i=1,3
		v(i)=p2(i)-p1(i)
	end do
	return
	end

*-------------------------------------------------------------------------------

