require 'spec_helper'

# - creation of keyspace
# - drop keyspace
# - migrate
# - rollback
#

describe CequelCQL2::Migrations::Rails::KeyspaceManager do
  describe "#new" do
    it "creates a CQL connection" do
      CequelCQL2::Migrations::Rails::KeyspaceManager.stub(:cequel_env_conf).and_return({ 'host' => 'some host' })
      CassandraCQL::Database.should_receive(:new).with('some host')
      CequelCQL2::Migrations::Rails::KeyspaceManager.new
    end
  end

  describe "#create_keyspace" do
    it "send cql to create the specified keyspace" do
      CequelCQL2::Migrations::Rails::KeyspaceManager.stub(:cequel_env_conf).and_return({ 'host' => 'some host', 'keyspace' => 'aoeuoae', 'strategy_class' => 'stratclass' })
      db = mock('db')
      CassandraCQL::Database.stub(:new).and_return(db)
      subject.stub(:build_create_keyspace_cmd).and_return('xxx')
      db.should_receive(:execute).with('xxx')
      subject.create_keyspace
    end
  end

  describe "#build_create_keyspace_cmd" do
    it "build the cql command string to create a keyspace" do
      CequelCQL2::Migrations::Rails::KeyspaceManager.stub(:cequel_env_conf).and_return({ 'host' => 'some host' })
      CassandraCQL::Database.stub(:new)
      subject.send(:build_create_keyspace_cmd, 'somename_keyspace_name', 'StrategyClass', { :replication_factor => 1 }).should == "CREATE KEYSPACE somename_keyspace_name WITH strategy_class = 'StrategyClass' AND strategy_options:replication_factor = 1"
    end

    it "builds the cql command string to create a keyspace without strategy_options" do
      CequelCQL2::Migrations::Rails::KeyspaceManager.stub(:cequel_env_conf).and_return({ 'host' => 'some host' })
      CassandraCQL::Database.stub(:new)
      subject.send(:build_create_keyspace_cmd, 'somename_keyspace_name', 'StrategyClass', nil).should == "CREATE KEYSPACE somename_keyspace_name WITH strategy_class = 'StrategyClass'"
    end
  end

  describe "#use_keyspace" do
    it "send the cql command to use the keyspace from the cequel_cql2.yml" do
      CequelCQL2::Migrations::Rails::KeyspaceManager.stub(:cequel_env_conf).and_return({ 'host' => 'some host', 'keyspace' => 'my_keyspace' })
      db = mock('db')
      CassandraCQL::Database.stub(:new).and_return(db)
      db.should_receive(:execute).with('USE my_keyspace')
      subject.use_keyspace
    end
  end

  describe "#drop_keyspace" do
    it "sends the cql comand to drop the keyspace from the cequel_cql2.yml" do
      CequelCQL2::Migrations::Rails::KeyspaceManager.stub(:cequel_env_conf).and_return({ 'host' => 'some host', 'keyspace' => 'my_keyspace' })
      db = mock('db')
      CassandraCQL::Database.stub(:new).and_return(db)
      db.should_receive(:execute).with('DROP KEYSPACE my_keyspace')
      subject.drop_keyspace
    end
  end
end
