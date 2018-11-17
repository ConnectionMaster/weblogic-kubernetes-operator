// Copyright 2018, Oracle Corporation and/or its affiliates.  All rights reserved.
// Licensed under the Universal Permissive License v 1.0 as shown at
// http://oss.oracle.com/licenses/upl.

package oracle.kubernetes.operator.helm;

import oracle.kubernetes.operator.create.CreateOperatorGeneratedFilesOptionalFeaturesEnabledTestBase;
import org.junit.BeforeClass;
import org.junit.Test;

public class CreateOperatorGeneratedFilesOptionalFeaturesEnabledIT
    extends CreateOperatorGeneratedFilesOptionalFeaturesEnabledTestBase {

  @BeforeClass
  public static void setup() throws Exception {
try {
    defineOperatorYamlFactory(new HelmOperatorYamlFactory());
} catch (Exception e) {
System.out.println("MOREAUT_DEBUG " + e);
e.printStackTrace();
throw e;
}
  }

  @Test
  @Override
  public void generatesCorrect_weblogicOperatorNamespace() {
    // the user is responsible for creating the namespace
  }

  @Test
  @Override
  public void generatesCorrect_weblogicOperatorServiceAccount() {
    // the user is responsible for creating the service account
  }
}
