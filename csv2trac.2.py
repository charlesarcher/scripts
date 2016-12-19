"""
Import tickets into a Trac database from a correctly formatted comma delimited file.

Requires:  Trac 0.9 or greater from http://trac.edgewall.com/
           Python 2.3 from http://www.python.org/
           
Author: Felix Collins felix at keyghost.com
Copyright: Felix Collins  2005 - 2006

Acknowledgement : This script borrows heavily from sourceforge2trac.py

Each line in the CSV file needs to have the following entries
        type            text           -- the ticket purpose
        time            integer        -- the time it was created
        changetime      integer
        component       text
        severity        text
        priority        text
        owner           text           -- who is this ticket assigned to
        reporter        text
        cc              text           -- email addresses to notify
        url             text           -- url related to this ticket
        version         text           -- 
        milestone       text           -- 
        status          text
        resolution      text
        summary         text           -- one-line summary
        description     text           -- problem description (long)
        keywords        text      
        
Any of the fields may be left blank except for type, status, severity and priority.
By default a blank field will be left blank in the ticket
If the summary field is blank then no ticket will be entered
If the time field is blank then the current time will be used

The component, version and milestone fields can use any value.  
These values will be entered into the component, version and milestone tables respectively.

type must be one of: task, defect, enhancement
status must be one of: new, assigned, reopened, closed
severity must be one of: blocker, critical, major, normal, minor, trivial, enhancement
priority must be one of: highest, high, normal, low, lowest

In addition to the above entries, custom fields are supported.
The name of the custom field should appear in the first row.
To enable processing of the custom fields by Trac you will need to put an entry in your trac.ini file
The following creates an entry for a field called "estimate".  
"estimate = text" defines estimate as a single line text entry.  See the Trac documentation
on custom fields for more help.

[ticket-custom]
estimate = text
estimate.label = First Estimate (hours)

Issues
This script does not do any checking of character formats.  It is therefore 
quite easy to get illegal characters into the database which will prevent Trac 
from displaying the ticket.  To avoid this stick to alphanumerics if possible.
Fixing problems of this nature requires manually removing the tickets from the 
database with the sqlite3 tool.

"""

from datetime import datetime
import trac.env
import csv
import time
import sys

#This function allow the script to be called from command line or programatically 
def Output(Content):
  if Output.CALLEDFROMCMD == True:
    print Content
  else:
    Output.outputstring = Output.outputstring + Content + "<br>" 
Output.outputstring = "" 
Output.CALLEDFROMCMD = False

class ImportedCSVData(object):
    def __init__(self, filename):
      
      #This code reads the file and just gets the field names 
      #This is done to support python 2.3 
      self.fileobject = open(filename, "rb")
      read = csv.reader(self.fileobject)
      fieldnames = read.next()

      #must rewind the file object after each use to a known location
      self.fileobject.seek(0)
      
      #work out what the custom fields are
      standardfields = ["type", "time", "changetime", "component", "severity", "priority", "owner", "reporter",
                        "cc", "url", "version", "milestone", "status", "resolution", "summary",
                        "description", "keywords"]
      self.customfields = []
      readstandardfields = []
      missingfields = []
      for field in fieldnames:
        if field not in standardfields:
          self.customfields.append(field)
        else:
          readstandardfields.append(field)

      if readstandardfields != standardfields:
        for field in standardfields:
          if field not in fieldnames:
            missingfields.append(field) 
        Output("Warning: missing fields in the csv file. Missing: %s" %missingfields)

      self.reader = csv.DictReader(self.fileobject, fieldnames + missingfields, restval="")

    #returns the DictReader with the tickets in it
    #remember that the reader can only be iterated through once without 
    #rewinding the file pointer (ImportedCSVData.reader.seek(0))
    def getnewtickets(self):
      return(self.reader)
      
    #returns a list of the custom fields defined in the csv file
    def getcustomfields(self):
      return(self.customfields)
        
    #returns a list of the component types needed for the import
    def getcomponents(self):
      components = []
      for row in self.reader:
        if row["summary"] != "summary":
          if row["component"] != "":
            if row["component"] not in components:
              components.append(row["component"])
      self.fileobject.seek(0)
      return(components)
      
    #returns a list of the versions needed for the import
    def getversions(self):
      versions = []
      for row in self.reader:
        if row["summary"] != "summary":
          if row["version"] != "":
            if row["version"] not in versions:
              versions.append(row["version"])
      self.fileobject.seek(0)
      return(versions)

      #returns a list of the milestones needed for the import
    def getmilestones(self):
      milestones = []
      for row in self.reader:
        if row["summary"] != "summary":
          if row["milestone"] != "":
            if row["milestone"] not in milestones:
              milestones.append(row["milestone"])
      self.fileobject.seek(0)
      return(milestones)
    

class TracDatabase(object):
    def __init__(self, path):
        self.env = trac.env.Environment(path)
        self._db = self.env.get_db_cnx()
        self._db.autocommit = False
    
    def db(self):
        return self._db
        
    #checks whether there are any existing tickets returns a boolean
    def hasTickets(self):
        c = self.db().cursor()
        c.execute('''SELECT count(*) FROM Ticket''')
        return int(c.fetchall()[0][0]) > 0
    
    def setComponentList(self, componentlist):
        """Remove all components, make new components from the entries in componentlist"""
        c = self.db().cursor()
        if self.hasTickets():
          #if we have tickets then we are importing into a working db
          #so get the existing components and only create new ones that don't already exist
          c.execute('SELECT (name) FROM component')
          rows = c.fetchall()
          if rows:
            for r in rows:
              if r[0] in componentlist:
                  componentlist.remove(r[0])
                  Output("Existing component detected: %s\n" %r[0])

        else: # no existing tickets therefore start from scratch  
          c.execute("""DELETE FROM component""")
          
        for value in componentlist:
            c.execute("""INSERT INTO component (name) VALUES ("%s")""" % value)
            Output("New component: %s" % value)
        self.db().commit()
    
    def setVersionList(self, versionlist):
        """Remove all versions, make new versions from the entries in versionlist"""
        c = self.db().cursor()
        if self.hasTickets():
          #if we have tickets then we are importing into a working db
          #so get the existing versions and only create new ones that don't already exist
          c.execute('SELECT (name) FROM version')
          rows = c.fetchall()
          if rows:
            for r in rows:
              if r[0] in versionlist:
                  versionlist.remove(r[0])
                  Output("Existing version detected: %s\n" %r[0])

        else: # no existing tickets therefore start from scratch  
          c.execute("""DELETE FROM version""")
        
        
        for value in versionlist:
            c.execute("""INSERT INTO version (name) VALUES ("%s")""" % value)
            Output("New version: %s" % value)
        self.db().commit()
        
    def setMilestoneList(self, milestonelist):
        """Remove all milestones, make new milestones from the entries in milestonelist"""
        c = self.db().cursor()
        
        if self.hasTickets():
          #if we have tickets then we are importing into a working db
          #so get the existing milestones and only create new ones that don't already exist
          c.execute('SELECT (name) FROM milestone')
          rows = c.fetchall()
          if rows:
            for r in rows:
              if r[0] in milestonelist:
                  milestonelist.remove(r[0])
                  Output("Existing milestone detected: %s\n" %r[0])

        else: # no existing tickets therefore start from scratch  
          c.execute("""DELETE FROM milestone""")


        for value in milestonelist:
            c.execute("""INSERT INTO milestone (name) VALUES ("%s")""" % value)
            Output("New milestone: %s" % value)
        self.db().commit()
    
    def addTicket(self, ttype, time, changetime, component,
                  severity, priority, owner, reporter, cc,
                  version, milestone, status, resolution,
                  summary, description, keywords):
        c = self.db().cursor()
        if status.lower() == 'open':
            if owner != '':
                status = 'assigned'
            else:
                status = 'new'

        c.execute('SELECT summary FROM ticket WHERE summary="%s"' %summary)
        rows = c.fetchall()
        if rows:
          Output("Existing ticket with matching summary exists - not overwriting %s" %summary)
          return 0
        else:
                
          c.execute('INSERT INTO ticket (type, time, changetime, component,\
                                           severity, priority, owner, reporter, cc,\
                                           version, milestone, status, resolution,\
                                           summary, description, keywords)\
                                   VALUES ("%s", "%s", "%s", "%s", "%s",\
                                           "%s", "%s", "%s", "%s", "%s",\
                                           "%s", "%s", "%s", "%s", "%s",\
                                           "%s")' %(
                    ttype, time, changetime, component,
                    severity, priority, owner, reporter,
                    cc, version, milestone, status.lower(),
                    resolution, summary, description, keywords))
          self.db().commit()
          return self.db().get_last_id(c, 'ticket')
          
    
    def addTicketCustom(self, ticket, name, value):
        c = self.db().cursor()
        c.execute("""INSERT INTO ticket_custom (ticket, name, value)
                                 VALUES        ("%s", "%s", "%s")""" %(
                  ticket, name, value))
        self.db().commit()


def main():
    import optparse
    Output.CALLEDFROMCMD = True
    p = optparse.OptionParser('usage: %prog newtickets.csv /path/to/trac/environment')
    opt, args = p.parse_args()
    if len(args) != 2:
        p.error("Incorrect number of arguments")
    
    try:
        importCSV(args[0], args[1])
    except Exception, e:
        Output('Error:%s' %e)

def importCSV(f, env):
  
    project = ImportedCSVData(f)
    
    db = TracDatabase(env)
    db.setComponentList(project.getcomponents())
    Output("Imported components")
    db.setVersionList(project.getversions())
    Output("Imported versions")
    db.setMilestoneList(project.getmilestones())
    Output("Imported milestones")
    
    tickets = project.getnewtickets()

    newid = 1
    linecount = 0
    for t in tickets:
      if t["summary"] != "summary":
        #Output("processing ticket %s" % t["summary"])
        linecount += 1
        
        #put current time in rows with no time
        tickettime = t["time"] 
        if tickettime == "":
          tickettime = int(time.time())

        #Don't import tickets with no summary 
        if t["summary"] != "":
         
          newid = db.addTicket(ttype=t["type"],
                           time=tickettime,
                           changetime=tickettime,
                           component=t["component"],
                           severity=t["severity"],
                           priority=t["priority"],
                           owner=t["owner"],
                           reporter=t["reporter"],
                           cc=t["cc"],
                           version=t["version"],
                           milestone=t["milestone"],
                           status=t["status"],
                           resolution=t["resolution"],
                           summary=t["summary"],
                           description=t["description"],
                           keywords=t["keywords"])
         
          if newid != 0:
            Output('Imported "%s" as ticket #%d' % (t["summary"], newid))
            #do the custom fields
            customfields = project.getcustomfields()
            for field in customfields:
              if t[field] != "":
                db.addTicketCustom(newid, field, t[field])
        else:
          Output("Warning: Ignored ticket with no summary at line %s" %linecount)
    Output('Finished importing')
    return Output.outputstring    

if __name__ == '__main__':
    main()