;;; Copyright (c) 2012, Lorenz Moesenlechner <moesenle@in.tum.de>
;;; All rights reserved.
;;; 
;;; Redistribution and use in source and binary forms, with or without
;;; modification, are permitted provided that the following conditions are met:
;;; 
;;;     * Redistributions of source code must retain the above copyright
;;;       notice, this list of conditions and the following disclaimer.
;;;     * Redistributions in binary form must reproduce the above copyright
;;;       notice, this list of conditions and the following disclaimer in the
;;;       documentation and/or other materials provided with the distribution.
;;;     * Neither the name of the Intelligent Autonomous Systems Group/
;;;       Technische Universitaet Muenchen nor the names of its contributors 
;;;       may be used to endorse or promote products derived from this software 
;;;       without specific prior written permission.
;;; 
;;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
;;; AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
;;; IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
;;; ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
;;; LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
;;; CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
;;; SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
;;; INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
;;; CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
;;; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;;; POSSIBILITY OF SUCH DAMAGE.

(in-package :cpm)

;;; This file contains a (empty) definitions of Prolog predicates to
;;; reason about which process modules should and can be used to
;;; execute a specific action designator. Important: Each process module
;;; should implement its version of the predicates!
;;;
;;; The predicate MATCHING-PROCESS-MODULE allows for inferring which
;;; process modules are suitable for executing an action designator,
;;; i.e. it should bind the name of the process module that can
;;; execute ?action-designator.
;;;
;;; The predicate AVAILABLE-PROCESS-MODULE holds for all process
;;; modules that are currently available. When projecting, it should
;;; only hold for the projection process modules of the current
;;; projection environment.
;;;
;;; The predicate PROJECTION-RUNNING allows to infer whether a specific
;;; projection process module is currently running. Regular process
;;; modules can use this predicate to decide whether they should make
;;; themselves available for plan execution. Basically, PROJECTION-RUNNING
;;; can act as a flag to hot-swap projection- and regular-process-modules.

(def-fact-group process-modules (matching-process-module available-process-module)

  (<- (matching-process-module ?action-designator ?process-module-name)
    (fail))

  (<- (available-process-module ?process-name)
    (fail))
  
  (<- (projection-running ?projection-process-module-name)
    (fail)))

(defun matching-process-module-names (action-designator)
  "Returns a list of process-module names which are available and claim they match the
 given designator `action-designator'."
  (force-ll
   (lazy-mapcar (lambda (bindings)
                  (var-value '?process-module-name bindings))
                (prolog `(and
                          (matching-process-module
                           ,action-designator ?process-module-name)
                          (available-process-module ?process-module-name))))))
